/**
 * ����:	 ҩ����������
 * ��д��:	 yunhaibao
 * ��д����: 2019-08-12
 */
var PHA_EXPORT = {
	/**
	 * 	����js�ɴ�js��������,���ټ��ؽ���ͬʱ����
	 * @param {Array} dataArr �������{"code":"AA","desc":"AAA"}
	 * @param {Array} dataArr �������[{"code":"AA","desc":"AAA"},{"code":"DA","desc":"DADA"}]
	 * @param {String} fileName �ļ���,Ĭ�Ͽ�ʱ��ʱ�������
	 */
	XLSX: function (title,data, fileName) {
		fileName = fileName || "���ݵ���_" + new Date().getTime() + ".xlsx"; // ��������
		var jsArr=[
			"/imedical/web/scripts/pha/plugins/xlsx/xlsx.full.min.js",
			"/imedical/web/scripts/pha/plugins/export-excel/FileSaver.js", 
			"/imedical/web/scripts/pha/plugins/export-excel/Blob.js"
		]
		PHA_EXPORT.LoadJS(jsArr,DoExport);
		function DoExport(){
			var keys = Object.keys(title);
			var firstRow = {}; // ����
			keys.forEach(function (item) {
				firstRow[item] = title[item];
			}); //���û��
			data.unshift(firstRow);
			var content = {};
			try {
				// ��json��ʽ������תΪexcel��������ʽ
				var sheetsData = data.map(function (item, rowIndex) {
					return keys.map(function (key, columnIndex) {
						if (title) {
							if (key in title) {
								/*return Object.assign({}, {
									value: item[key],
									position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
								});*/
								return {
									value: item[key],
									position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
								};
							}
						} else {
							/*return Object.assign({}, {
								value: item[key],
								position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
							});*/
							return {
								value: item[key],
								position: (columnIndex > 25 ? getCharCol(columnIndex) : String.fromCharCode(65 + columnIndex)) + (rowIndex + 1),
							};
						}
	
					});
				}).reduce(function (prev, next) {
					return prev.concat(next);
				});
				//console.log(sheetsData);
	
				sheetsData.forEach(function (item, index) {
					if (item) {
						var cellVal=item.value||""; 
						if (cellVal!=""){
							cellVal=cellVal.replace(/<\/br>/g,String.fromCharCode(10));
						}
						content[item.position] = {
							v: cellVal //,
							// r: item.value,
							// w: item.value,
							// h:item.value
							// t:"s"
						};
					}
				});
	
				//��������,�������A1��D10,SheetNames:����
				var coordinate = Object.keys(content);
				var CellsZone = {
					"!ref": coordinate[0] + ":" + coordinate[coordinate.length - 1]
				};

				var workBook = {
					SheetNames: ["Sheet1"],
					Sheets: {
						"Sheet1": extend(content, CellsZone) //Object.assign({}, content, { "!ref": coordinate[0] + ":" + coordinate[coordinate.length - 1] })
					}
				};
				//������������������嵼���ĸ�ʽ����
				var excelData = XLSX.write(workBook, {
					bookType: "xlsx",
					bookSST: false,
					type: "binary" //,
					//ignoreEC:false
				});
				// const wopts = { bookType: 'csv', bookSST: false, type: 'binary' };//ods��ʽ
				// const wopts = { bookType: 'ods', bookSST: false, type: 'binary' };//ods��ʽ
				// const wopts = { bookType: 'xlsb', bookSST: false, type: 'binary' };//xlsb��ʽ
				// const wopts = { bookType: 'fods', bookSST: false, type: 'binary' };//fods��ʽ
				// const wopts = { bookType: 'biff2', bookSST: false, type: 'binary' };//xls��ʽ
		
				var blob = new Blob([string2ArrayBuffer(excelData)], {
					type:"application/octet-stream" //type: "application/vnd.ms-excel"
				});
				saveAs(blob, fileName); // scripts/filehandingutiljs/FileSaver.min.js
			} catch (e) {
				alert(e.message);
			}
	
			//�ַ���ת�ַ���
			function string2ArrayBuffer(s) {
				var buf = new ArrayBuffer(s.length);
				var view = new Uint8Array(buf);
				for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
				return buf;
			}
	
			// ��ָ������Ȼ��ת��Ϊ26���Ʊ�ʾ��ӳ���ϵ��[0-25] -> [A-Z]��
			function getCharCol(n) {
				var temCol = "";
				var s = "";
				var m = 0;
				while (n > 0) {
					m = n % 26 + 1
					s = String.fromCharCode(m + 64) + s
					n = (n - m) / 26
				}
				return s
			}
	
			//�ϲ�����,ԭ������IE��֧��Object.assign()�����ϲ�����
			function extend(target, source) {
				for (var obj in source) {
					target[obj] = source[obj];
				}
				return target;
			}

		}
	},
	// ��̬����JS���Ѵ��ڲ������
	LoadJS: function (srcArr, callBack) {
		var loadCnt = srcArr.length;
		var loadI = 0;
		Create();

		function Create() {
			if (loadI >= loadCnt) {
				callBack(loadI);
				return;
			}
			var src = srcArr[loadI];
			if (IsExist(src) == true) {
				loadI++;
				Create();
			} else {
				var head = document.getElementsByTagName('head')[0];
				var script = document.createElement('script');
				script.type = 'text/javascript';
				script.src = src;
				script.charset="utf-8"
				head.appendChild(script);
				script.onload = function () {
					loadI++;
					Create();
				}
			}
		}

		function IsExist(src) {
			var scriptArr = document.getElementsByTagName('script');
			for (var i = 0; i < scriptArr.length; i++) {
				var tmpSrc=src.replace("/imedical/web/","")
				if ((scriptArr[i].src).indexOf(tmpSrc.replace("../", "")) >= 0) {
					return true;
				}
			}
			return false;
		}
	}
}