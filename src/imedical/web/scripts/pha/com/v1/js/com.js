/**
 * ����:	 ҩ������
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
 */
var PHA_COM = {
	/**
	 * ��Ӧÿ����Ʒ�˵���cspȫ��,ע���Сд
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
	 * �ǼǺŲ���
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
				Chinese: '<font color="#21ba45">��</font>'
			},
			No: {
				Icon: '<img src="../scripts_lib/hisui-0.1.0/dist/css/icons/close.png"></img>',
				Chinese: '<font color="#f16e57">��</font>'
			}
		}
	},
	/**
	 * ����grid���ݵ�excel
	 * @param {String} _id ���Id 
	 */
	ExportGrid: function (_id, _fileName) {
		_fileName = _fileName || "���ݵ���_" + new Date().getTime() + ".xlsx"; // ��������
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
		// ȡ����,url��һ����$URL
		var queryParams = $grid.datagrid("options").queryParams;
		var url = $grid.datagrid("options").url;
		if (url.indexOf("?") < 0) {
			url = url + "?";
		}
		url += "&page=1&rows=9999";
		PHA.Loading("Show");
		// ��������ʧ
		$.ajax({
			type: "GET",
			url: url,
			async: true,
			data: queryParams,
			dataType: "json",
			success: function (data) {
				PHA.Loading("Hide");
				// ��������data
				var rowsData=data.rows;
				PHA_UTIL.LoadJS(["../scripts/pha/com/v1/js/export.js"],function(){
					PHA_EXPORT.XLSX(titleObj,rowsData,_fileName);
				});
			}
		});
	},
	/**
	 * 
	 * @param {json} _data json��ʽ����
	 * @param {Array} _cm �ɵ�����col����
	 */
	ExportData: function (_data, _cmArr, _fileName) {
		var dataArr = [];
		// ������
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
						if (/(<[a-z].*>).*(<\/[a-z].*>$)/g.test(cellData)) { // ��<das></dsa>�����ʽȡԭʼֵ
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
	 * @description ��ȡexcel����
	 * ʹ��ʱ�赥������ 
	 * <script type="text/javascript" src="../scripts/pha/plugins/xlsx/xlsx.full.min.js"></script>
	 */
	ReadExcel: function (file, callBack) {
		// �ȹ̶���ôд
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
			// result ��Ϊ��������
			// ���ݸ�ʽ,LocDesc��Ϊ���б���,����Ӧ���Լ�����
			// [{LocDesc: 1, InciCode: 2, InciDesc: 3, PHCDFSCDIDr: 4, PHCDFMenstruumFlag: 5}]	
		}
		reader.readAsBinaryString(file);
	},
	GenHospCombo:function(_options){
		var tableName = _options.tableName || '';
		if (tableName===''){
			$.messager.alert('��ʾ', '�������,δ����Ȩ���������', 'error');	
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
	                '           <label id="_HospListLabel" style="color:red;">ҽԺ</label>' +
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