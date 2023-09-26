/**
 * 名称:	 药房公共导出
 * 编写人:	 yunhaibao
 * 编写日期: 2019-08-12
 */
var PHA_EXPORT = {
	/**
	 * 	所需js由此js单独加载,不再加载界面同时加载
	 * @param {Array} dataArr 表格数据{"code":"AA","desc":"AAA"}
	 * @param {Array} dataArr 表格数据[{"code":"AA","desc":"AAA"},{"code":"DA","desc":"DADA"}]
	 * @param {String} fileName 文件名,默认空时按时间点生成
	 */
	XLSX: function (title,data, fileName) {
		fileName = fileName || "数据导出_" + new Date().getTime() + ".xlsx"; // 待加日期
		var jsArr=[
			"/imedical/web/scripts/pha/plugins/xlsx/xlsx.full.min.js",
			"/imedical/web/scripts/pha/plugins/export-excel/FileSaver.js", 
			"/imedical/web/scripts/pha/plugins/export-excel/Blob.js"
		]
		PHA_EXPORT.LoadJS(jsArr,DoExport);
		function DoExport(){
			var keys = Object.keys(title);
			var firstRow = {}; // 标题
			keys.forEach(function (item) {
				firstRow[item] = title[item];
			}); //这段没用
			data.unshift(firstRow);
			var content = {};
			try {
				// 把json格式的数据转为excel的行列形式
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
	
				//设置区域,比如表格从A1到D10,SheetNames:标题
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
				//这里的数据是用来定义导出的格式类型
				var excelData = XLSX.write(workBook, {
					bookType: "xlsx",
					bookSST: false,
					type: "binary" //,
					//ignoreEC:false
				});
				// const wopts = { bookType: 'csv', bookSST: false, type: 'binary' };//ods格式
				// const wopts = { bookType: 'ods', bookSST: false, type: 'binary' };//ods格式
				// const wopts = { bookType: 'xlsb', bookSST: false, type: 'binary' };//xlsb格式
				// const wopts = { bookType: 'fods', bookSST: false, type: 'binary' };//fods格式
				// const wopts = { bookType: 'biff2', bookSST: false, type: 'binary' };//xls格式
		
				var blob = new Blob([string2ArrayBuffer(excelData)], {
					type:"application/octet-stream" //type: "application/vnd.ms-excel"
				});
				saveAs(blob, fileName); // scripts/filehandingutiljs/FileSaver.min.js
			} catch (e) {
				alert(e.message);
			}
	
			//字符串转字符流
			function string2ArrayBuffer(s) {
				var buf = new ArrayBuffer(s.length);
				var view = new Uint8Array(buf);
				for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
				return buf;
			}
	
			// 将指定的自然数转换为26进制表示。映射关系：[0-25] -> [A-Z]。
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
	
			//合并对象,原方法中IE不支持Object.assign()方法合并对象
			function extend(target, source) {
				for (var obj in source) {
					target[obj] = source[obj];
				}
				return target;
			}

		}
	},
	// 动态加载JS，已存在不会加载
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