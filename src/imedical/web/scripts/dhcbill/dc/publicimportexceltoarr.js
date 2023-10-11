/*
*Excel�ļ����룬ת������
*FileName: dhcbill\dc\publicimportexceltoarr.js
*zjb 2023/11/11
*/
var ImportObj={
	/**
	 * �����ļ�/��ȡ�ļ������� (���Ե����ĸ�ʽ: xls/xlsx/txt/jpg/gif)
	 * 
	 * @param {Object} 	_options.charset: ��ȡ���ļ�����, ����: utf-8 / gb2312
	 * 				  	_options.FileSuffixname: �ļ���ʽ��֤������ʽ, ����: /^(.xls)|(.xlsx)$/
	 * @param {Function}  data: �ص�����
	 * others: ImportFile.ImportFile()
	 */
	ImportFile: function (_options, _callFn) {
		// ���崴���ļ��򷽷�
		var createFileBox = function (_thisCall) {
			var inputFileBox = document.createElement('input');
			inputFileBox.type = 'file';
			inputFileBox.onchange = function () {
				var files = this.files || [];
				if (files.length == 0) {
					$.messager.alert("��ʾ",'δѡ���ļ�!');
					return;
				}
				var file = files[0];
				var fileName = file.name;
				var reversedArr = fileName.split('.');
				var reversedLen = reversedArr.length;
				var fileSuffix = '.' + reversedArr[reversedLen - 1]; // �ļ���׺

				var defaultReg = /^(.xml)|(.txt)|(.xls)|(.xlsx)|(.jpg)|(.gif)$/;
				var suffixReg = _options.suffixReg || defaultReg;
				if (suffixReg == '') {
					suffixReg = defaultReg;
				}
				var suffixRegStr = suffixReg.toString().replace('/^', '').replace('$/', '');

				if (suffixReg.test(fileSuffix) == false) {
					$.messager.alert("��ʾ",'�ļ���ʽ����, ��ѡ���׺Ϊ: ' + suffixRegStr + ' ���ļ�!');
					return;
				}
				_thisCall && _thisCall(file);
			};
			document.body.appendChild(inputFileBox);
			inputFileBox.click();
		};
		// �����ȡ�ļ�����ڷ���
		var readFile = function (file) {
			if (!file) {
				$.messager.alert("��ʾ",'δѡ���ļ�!');
				return;
			}
			var fileName = file.name || '';
			if (fileName == '') {
				$.messager.alert("��ʾ",'δѡ���ļ�!');
				return;
			}
			var reversedArr = fileName.split('.');
			var reversedLen = reversedArr.length;
			var fileSuffix = '.' + reversedArr[reversedLen - 1]; // �ļ���׺
			if (fileSuffix == '.xls' || fileSuffix == '.xlsx') {
				ImportObj.ReadExcel(file, function (data, workBook) {
					_callFn && _callFn(data, file, workBook); // read excel, this data is json
				});
			} else {
				readAsData(file, function (data) {
					_callFn && _callFn(data, file); // data is text
				});
			}
		};
		// �����ȡ txt & xml & img �ķ���
		var readAsData = function (file, _thisCall) {
			if (!FileReader) {
				$.messager.alert("��ʾ",'�������֧��FileReader,��ʹ��Chrome');
				return;
			}
			var _mCharset = _options.charset || 'gb2312' || 'utf-8';
			var reader = new FileReader();
			if (/text+/.test(file.type)) {
				reader.onload = function () {
					_thisCall && _thisCall(this.result);
				};
				reader.readAsText(file, _mCharset); /*��ȡ�ı��ļ�*/
			} else if (/image+/.test(file.type)) {
				reader.onload = function () {
					_thisCall && _thisCall(this.result);
				};
				reader.readAsDataURL(file); /*��ȡͼƬ�ļ�*/
			} else {
				$.messager.alert("��ʾ",'���ܶ�ȡtxt & xml & img�ļ�');
			}
		};
		createFileBox(readFile);
	},
	/**
	 * @description ��ȡexcel����
	 * ʹ��ʱ�赥������
	 * <script type="text/javascript" src="../scripts/dhcbill/dc/publicimportexceltoarr.js"></script>
	 */
	ReadExcel: function (file, callBack) {
		var reader = new FileReader();
		reader.onload = function (e) {
			if (reader.result) {
				reader.content = reader.result;
			}
			// In IE browser event object is null
			var data = e ? e.target.result : reader.content;
			// var baseEncoded = btoa(data);
			// var wb = XLSX.read(baseEncoded, {type: 'base64'});
			workBook = XLSX.read(data, {
				type: 'binary'
			});
			var jsonData = {};
			var result = XLSX.utils.sheet_to_json(workBook.Sheets[workBook.SheetNames[0]]);
			callBack(result, workBook);
		};
		reader.readAsBinaryString(file);
	},
}