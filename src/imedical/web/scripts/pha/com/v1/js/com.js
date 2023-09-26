/**
 * 名称:	 药房公共
 * 编写人:	 yunhaibao
 * 编写日期: 2019-03-12
 */
var PHA_COM = {
	/**
	 * 对应每个产品菜单的csp全称,注意大小写
	 */
	Param: {
		Com: {},
		App: {}
	},
	App: {
		Csp: "",
		Name: "",
		Load: ""
	},
	Session: {
		ALL: session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'] + "^" + session['LOGON.GROUPID'] + "^" + session['LOGON.HOSPID'],
		USERID: session['LOGON.USERID'],
		CTLOCID: session['LOGON.CTLOCID'],
		HOSPID: session['LOGON.HOSPID'],
		GROUPID: session['LOGON.GROUPID']
	},
	Ele: {

	},
	/**
	 * 登记号补零
	 * @param {String} _patNo 
	 */
	FullPatNo: function (_patNo) {
		return $.cm({
			ClassName: 'PHA.COM.Method',
			MethodName: 'FullPatNo',
			PatNo: _patNo,
			dataType: "text"
		}, false);
	},
	Input: function () {
		this.Main = {};
		this.Detail = [];
		this.Logon = {
			UserId: session['LOGON.USERID'],
			LocId: session['LOGON.CTLOCID'],
			HospId: session['LOGON.HOSPID'],
			GrpId: session['LOGON.GROUPID']
		}
	},
	Fmt: {
		Grid: {
			Yes: {
				Icon: '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/ok.png"></img>',
				Chinese: '<font color="#21ba45">是</font>'
			},
			No: {
				Icon: '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/close.png"></img>',
				Chinese: '<font color="#f16e57">否</font>'
			}
		}
	},
	/**
	 * 导出grid数据导excel
	 * @param {String} _id 表格Id 
	 */
	ExportGrid: function (_id, _fileName) {
		_fileName = _fileName || "数据导出_" + new Date().getTime() + ".xlsx"; // 待加日期
		var $grid = $("#" + _id);
		var newCols;
		var cols = $grid.datagrid("options").columns[0];
		var frozenCols = $grid.datagrid("options").frozenColumns[0];
		if (frozenCols != undefined) {
			newCols = frozenCols.concat(cols);
		} else {
			newCols = cols;
		}
		var mField = "";
		var titleObj = {}
		for (var ncI = 0; ncI < newCols.length; ncI++) {
			var colIModal = newCols[ncI];
			if ((colIModal.hidden) || (colIModal.checkbox)) {
				continue;
			}
			mField = colIModal.descField ? colIModal.descField : colIModal.field;
			titleObj[mField] = colIModal.title;
		}
		// 取参数,url不一定是$URL
		var queryParams = $grid.datagrid("options").queryParams;
		var url = $grid.datagrid("options").url;
		if (url.indexOf("?") < 0) {
			url = url + "?";
		}
		url += "&page=1&rows=9999";
		PHA.Loading("Show");
		// 遮罩与消失
		$.ajax({
			type: "GET",
			url: url,
			async: true,
			data: queryParams,
			dataType: "json",
			success: function (data) {
				PHA.Loading("Hide");
				// 重新序列data
				var rowsData=data.rows;
				PHA_UTIL.LoadJS(["../scripts/pha/com/v1/js/export.js"],function(){
					PHA_EXPORT.XLSX(titleObj,rowsData,_fileName);
				});
			}
		});
	},
	/**
	 * 
	 * @param {json} _data json格式数据
	 * @param {Array} _cm 可导出的col属性
	 */
	ExportData: function (_data, _cmArr, _fileName) {
		var dataArr = [];
		// 标题列
		var titleArr = []
		for (var colI = 0; colI < _cmArr.length; colI++) {
			var colIModal = _cmArr[colI];
			if ((colIModal.hidden) || (colIModal.checkbox)) {
				continue;
			}
			titleArr.push(colIModal.title);
		}
		dataArr.push(titleArr);
		var rowsLen = _data.length;
		for (var i = 0; i < rowsLen; i++) {
			var rowData = _data[i];
			var oneRowArr = [];
			for (var colI = 0; colI < _cmArr.length; colI++) {
				var colIModal = _cmArr[colI];
				var field = colIModal.field;

				if ((colIModal.hidden) || (colIModal.checkbox)) {
					continue;
				}
				if (colIModal.descField) {
					cellData = rowData[colIModal.descField];
				} else {
					var formater = colIModal.formatter;
					var cellData = "";
					if (formater) {
						cellData = formater(rowData[field], rowData);
						if (/(<[a-z].*>).*(<\/[a-z].*>$)/g.test(cellData)) { // 有<das></dsa>此类格式取原始值
							cellData = rowData[field];
						}
					} else {
						cellData = rowData[field];
					}
				}
				var regExp = /^([0-9]\d*)-([0-9]\d*)-([0-9]\d*)$/; // x-x-x
				var regExpT = /^([0-9]\d*)-([0-9]\d*)-([0-9]\d*) ([0-9]\d*):([0-9]\d*):([0-9]\d*)$/; // x-x-x b:b:b 
				if ((regExp.test(cellData) == true) || (regExpT.test(cellData) == true)) {
					cellData = "'" + cellData;
				}
				if ((parseInt(cellData) == cellData) && (cellData != 0)) {
					if (cellData.toString().charAt(0) == 0) {
						cellData = "'" + cellData;
					}
				}
				if (cellData.indexOf("</br>") >= 0) {
					cellData = '"' + cellData + '"';
					cellData = cellData.replace(/<\/br>/g, "\r\n");
				}
				oneRowArr.push(cellData);
			}
			dataArr.push(oneRowArr)
		}

		ExportUtil.toExcel(dataArr, _fileName);
	},
	/**
	 * @description 读取excel数据
	 * 使用时需单独引用 
	 * <script type="text/javascript" src="../scripts/pha/plugins/xlsx/xlsx.full.min.js"></script>
	 */
	ReadExcel: function (file, callBack) {
		// 先固定这么写
		if (!FileReader.prototype.readAsBinaryString) {
			FileReader.prototype.readAsBinaryString = function (fileData) {
				var binary = '';
				var pk = this;
				var reader = new FileReader();
				reader.onload = function (e) {
					var bytes = new Uint8Array(reader.result);
					var length = bytes.byteLength;
					for (var i = 0; i < length; i++) {
						var a = bytes[i];
						var b = String.fromCharCode(a)
						binary += b;
					}
					pk.content = binary;
					$(pk).trigger('onload');
				}
				reader.readAsArrayBuffer(fileData);
			}
		}
		var reader = new FileReader();
		reader.onload = function (e) {
			if (reader.result) {
				reader.content = reader.result;
			}
			//In IE browser event object is null
			var data = e ? e.target.result : reader.content;
			//var baseEncoded = btoa(data);
			//var wb = XLSX.read(baseEncoded, {type: 'base64'});
			workBook = XLSX.read(data, {
				type: 'binary'
			});
			var jsonData = {};
			var result = XLSX.utils.sheet_to_json(workBook.Sheets[workBook.SheetNames[0]]);
			callBack(result)
			// result 即为所有数据
			// 数据格式,LocDesc等为首行标题,具体应用自己定义
			// [{LocDesc: 1, InciCode: 2, InciDesc: 3, PHCDFSCDIDr: 4, PHCDFMenstruumFlag: 5}]	
		}
		reader.readAsBinaryString(file);
	},
	GenHospCombo:function(_options){
		var tableName = _options.tableName || '';
		if (tableName===''){
			$.messager.alert('提示', '程序错误,未传授权表名或代码', 'error');	
			return;
		}
	    var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
	    if (hospAutFlag === 'Y') {
	        $($('body>.hisui-layout')[0]).layout('add', {
	            region: 'north',
	            border: false,
	            height: 40,
				split:false,
	            bodyCls: 'pha-ly-hosp',
	            content:
	                '<div style="padding-left:10px;">' +
	                '   <div class="pha-row">' +
	                '       <div class="pha-col">' +
	                '           <label id="_HospListLabel" style="color:red;">医院</label>' +
	                '       </div>' +
	                '   	<div class="pha-col">' +
	                '       	<input id="_HospList" class="textbox"/>' +
	                '   	</div>' +
	                '	</div>' +
	                '</div>'
	        });
	        var genHospObj=GenHospComp(tableName);
			return genHospObj;
	    }else{
			return "";
		}		 
	}
}