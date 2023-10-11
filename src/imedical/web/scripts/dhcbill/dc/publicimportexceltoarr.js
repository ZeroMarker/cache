/*
*Excel文件导入，转成数组
*FileName: dhcbill\dc\publicimportexceltoarr.js
*zjb 2023/11/11
*/
var ImportObj={
	/**
	 * 导入文件/读取文件的数据 (可以导出的格式: xls/xlsx/txt/jpg/gif)
	 * 
	 * @param {Object} 	_options.charset: 读取的文件编码, 例如: utf-8 / gb2312
	 * 				  	_options.FileSuffixname: 文件格式验证正则表达式, 例如: /^(.xls)|(.xlsx)$/
	 * @param {Function}  data: 回调函数
	 * others: ImportFile.ImportFile()
	 */
	ImportFile: function (_options, _callFn) {
		// 定义创建文件框方法
		var createFileBox = function (_thisCall) {
			var inputFileBox = document.createElement('input');
			inputFileBox.type = 'file';
			inputFileBox.onchange = function () {
				var files = this.files || [];
				if (files.length == 0) {
					$.messager.alert("提示",'未选择文件!');
					return;
				}
				var file = files[0];
				var fileName = file.name;
				var reversedArr = fileName.split('.');
				var reversedLen = reversedArr.length;
				var fileSuffix = '.' + reversedArr[reversedLen - 1]; // 文件后缀

				var defaultReg = /^(.xml)|(.txt)|(.xls)|(.xlsx)|(.jpg)|(.gif)$/;
				var suffixReg = _options.suffixReg || defaultReg;
				if (suffixReg == '') {
					suffixReg = defaultReg;
				}
				var suffixRegStr = suffixReg.toString().replace('/^', '').replace('$/', '');

				if (suffixReg.test(fileSuffix) == false) {
					$.messager.alert("提示",'文件格式错误, 请选择后缀为: ' + suffixRegStr + ' 的文件!');
					return;
				}
				_thisCall && _thisCall(file);
			};
			document.body.appendChild(inputFileBox);
			inputFileBox.click();
		};
		// 定义读取文件的入口方法
		var readFile = function (file) {
			if (!file) {
				$.messager.alert("提示",'未选择文件!');
				return;
			}
			var fileName = file.name || '';
			if (fileName == '') {
				$.messager.alert("提示",'未选择文件!');
				return;
			}
			var reversedArr = fileName.split('.');
			var reversedLen = reversedArr.length;
			var fileSuffix = '.' + reversedArr[reversedLen - 1]; // 文件后缀
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
		// 定义读取 txt & xml & img 的方法
		var readAsData = function (file, _thisCall) {
			if (!FileReader) {
				$.messager.alert("提示",'浏览器不支持FileReader,请使用Chrome');
				return;
			}
			var _mCharset = _options.charset || 'gb2312' || 'utf-8';
			var reader = new FileReader();
			if (/text+/.test(file.type)) {
				reader.onload = function () {
					_thisCall && _thisCall(this.result);
				};
				reader.readAsText(file, _mCharset); /*读取文本文件*/
			} else if (/image+/.test(file.type)) {
				reader.onload = function () {
					_thisCall && _thisCall(this.result);
				};
				reader.readAsDataURL(file); /*读取图片文件*/
			} else {
				$.messager.alert("提示",'仅能读取txt & xml & img文件');
			}
		};
		createFileBox(readFile);
	},
	/**
	 * @description 读取excel数据
	 * 使用时需单独引用
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