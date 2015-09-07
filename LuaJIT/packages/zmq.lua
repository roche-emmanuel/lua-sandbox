-- definition of ZMQ bindings:

local ffi = require("ffi")
ffi.cdef[[
int zmq_errno (void);
void *zmq_ctx_new (void);
int zmq_ctx_term (void *context);

void *zmq_socket (void *, int type);
int zmq_close (void *s);
int zmq_bind (void *s, const char *addr);
int zmq_connect (void *s, const char *addr);
]]

local lib = ffi.load("libzmq")

local zmq = {}

-- Context handling:

local context = nil

zmq.init = function()
	if context == nil then
		print("Initializing ZMQ context.")
		context = lib.zmq_ctx_new();
		if context==nil then
			error("Error in zmq_ctx_new(): error: ".. lib.zmq_errno());
		end
	end
end

zmq.uninit = function()
	if context ~= nil then
		local res = lib.zmq_ctx_term(context);
		if res ~= 0 then
			error("Error in zmq_ctx_term(): error: ".. lib.zmq_errno());
		end
		context = nil
	end
end

-- Socket handling:
local Socket = {}

function Socket:new(stype)
	
	local o = {}
	o._s = nil;

  setmetatable(o, self)
  self.__index = self
  
  o:open(stype)
  return o
end

local close_socket = function(s)
	print("Closing socket object.")
	if lib.zmq_close(s) ~= 0 then
		error("Error in zmq_close(): error: ".. lib.zmq_errno())
	end
end

function Socket:__gc()
	print("Calling table finalizer")
end

function Socket:close()
	if self._s then
		ffi.gc(self._s,nil)
		close_socket(self._s)
		self._s = nil
	end
end

function Socket:open(stype)
	self:close()

	zmq.init()

	self._s = lib.zmq_socket(context,stype);
	if self._s == nil then
		error("Error in zmq_socket(): error: ".. lib.zmq_errno())
	else
		ffi.gc(self._s,close_socket)
	end
end

function Socket:bind(endpoint)
	assert(self._s)
	if lib.zmq_bind(self._s,endpoint) ~= 0 then
		error("Error in zmq_bind(): error: ".. lib.zmq_errno())
	end
end

-- function Socket:connect(endpoint)
-- 	assert(self._s)
-- 	if lib.zmq_bind(self._s,endpoint) ~= 0 then
-- 		error("Error in zmq_bind(): error: ".. lib.zmq_errno())
-- 	end
-- end

-- method used to create a socket:
zmq.socket = function(stype)
	return Socket:new(stype)
end


return zmq;
