
/**
����Url�д���˫�����ַ������д���
 */
function encodeUrlStr(Params) {
	// ��cache���뷽ʽ����һ��
	Params = escape(Params).replace(/%u/g, '__u');
	return Params;
}