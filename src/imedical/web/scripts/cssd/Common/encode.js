
/**
对于Url中带有双引号字符串进行处理
 */
function encodeUrlStr(Params) {
	// 与cache解码方式保持一致
	Params = escape(Params).replace(/%u/g, '__u');
	return Params;
}