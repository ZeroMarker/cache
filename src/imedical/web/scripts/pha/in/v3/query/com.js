/**
 * ����:	 ҩ��V3 - ��ѯģ�鹫��
 * ��д��:	 pushuangcai
 * ��д����: 2022-03-15
 */
var ParamProp = PHA_COM.ParamProp('DHCSTLOCITMSTK');
var QUE_COM = {
	ComVal: {
		BgColor: {
			Expired: 'gray',
			NearlyExp: '#FF6565'
		}
	},
	/**
	 * ���ر���й����¼�
	 * @params {object} gridId datagrid��id
	 */
	ComGridEvent: function(gridId, event){
		if (QUE_COM.Grid.EventClassArr.length === 0){
			return;	
		}
		PHA.GridEvent(gridId, event || 'click', QUE_COM.Grid.EventClassArr, 
			function(rowIndex, rowData, className){
				QUE_COM.Grid.GridMethodPorxy(className).call(null, rowIndex, rowData, className, gridId);
			}
		)
	},
	Grid: {
		EventClassArr: [],
		GridMethodPorxy: function(className, gridId){
			switch (className){
				case "pha-grid-a js-grid-inciCode" : 
					return function(rowIndex, rowData){
						PHA_UX.DrugDetail({}, {inci: rowData.inci});
					}
				case "pha-grid-a js-grid-btTips icon icon-alert-red" : 
					return function(rowIndex, rowData, className, gridId){
						var target = $('#' + gridId).parent()
				        	.find('.datagrid-body-inner, .datagrid-body')
				        	.find('tr[datagrid-row-index="'+ rowIndex +'"]')
				        	.find('td[field="btTips"]')
				        	.find('a');
						var content = QUE_COM.LcBtOrdTips(rowData.btTips);
						$(target).popover({
							content: content,
							trigger: 'click',
							style: 'inverse'
						}); 
						$(target).popover('show');
					}
					case "pha-grid-a js-grid-bizNo" : {
						return function (rowIndex, rowData){
							PHA_UX.BusiTimeLine({
								left: $('body').width() - 420
							},{
								busiCode: rowData.bizCode,
								locId: $("#locId").combobox("getValue") || PHA_COM.Session.CTLOCID,
								pointer: rowData.pointer.split("||")[0],
								No: rowData.bizNo
							});
						}
					}
					case "pha-grid-a js-grid-TransNo": {
						return function (rowIndex, rowData){
							PHA_UX.BusiTimeLine({
								left: $('body').width() - 420
							},{
								busiCode: "TRANS",
								locId: $("#locId").combobox("getValue") || PHA_COM.Session.CTLOCID,
								pointer: rowData.initItmId.split("||")[0],
								No: rowData.TransNo
							});
						}
					}
				default : return function(){};
			}
		},
		Styler: {
			ExpDate: function(value, rowData, rowIndex){
				if (typeof value === "undefined"){
					return "";	
				}
				if (typeof rowData.expMonths === "undefined"){
					rowData.expMonths = GetInciExpMonths(value);
				}
				if (typeof rowData.expDays === "undefined"){
					rowData.expDays = GetDaysForDateByDate(value);
				}
				if ((rowData.expMonths <= 0) && (rowData.expDays <= 0)){
					return "background:"+ QUE_COM.ComVal.BgColor.Expired +";color:white;font-weight: 600;";	
				} 
				if(rowData.expDays <= ParamProp.ExpDateWarnDays){
					return "background:"+ QUE_COM.ComVal.BgColor.NearlyExp +";color:white;font-weight: 600;";	
				} 
				return "";
			}
		},
		_ColHtml: function(value, colClass){
			return '<a class="'+ colClass +'">' + value + '</a>';
		},
		_ColStateHtml: function(bgcolor, text){
			var stateHtml = "<div style='padding:1px;background-color:"+ bgcolor +";border-radius:3px;'>";
				stateHtml += "	<label style='color:white;font-weight:600;'>"+ text +"</label>";
				stateHtml += "</div>";
			return stateHtml;
		},
		Formatter: {
			YesOrNo: function(){
				return function (value, rowData, index) {
					if (typeof value === "undefined") { return; }
					if (value == 'Y') {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			},
			InciCode: function(){
				var colClass = "pha-grid-a js-grid-inciCode";
				QUE_COM.Grid.EventClassArr.push(colClass);	
							
				return function (value, rowData, index) {
					if (!value){ return ""; }
					if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("�ϼ�") > -1)){
						return "";	
					}
					return QUE_COM.Grid._ColHtml(value, colClass);
				}
			},
			ExpState: function(){
				return function(value, rowData, rowIndex){
					if (typeof rowData.expDate === "undefined"){
						return "";
					}
					if (typeof rowData.expMonths === "undefined"){
						rowData.expMonths = GetInciExpMonths(rowData.expDate);
					}
					if (typeof rowData.expDays === "undefined"){
						rowData.expDays = GetDaysForDateByDate(rowData.expDate);
					}
					var text = "";
					var bgcolor = "";
					if (rowData.expDays <= 0){
						text = $g("�ѹ���");
						bgcolor = QUE_COM.ComVal.BgColor.Expired;
					} else if (rowData.expDays <= ParamProp.ExpDateWarnDays){
						text = $g("��Ч��");
						bgcolor = QUE_COM.ComVal.BgColor.NearlyExp;
					} else{
						text = $g("����");
						bgcolor = "#00BA89";
					}
					return QUE_COM.Grid._ColStateHtml(bgcolor, text);
				}
			},
			ExpDate: function(){
				return function(value, rowData, rowIndex){
					if (!value) { return ""; }
					if (typeof rowData.expMonths === "undefined"){
						rowData.expMonths = GetInciExpMonths(value);
					}
					if (typeof rowData.expDays === "undefined"){
						rowData.expDays = GetDaysForDateByDate(value);
					}
					var text = "";
					if (rowData.expDays <= 0){
						text = $g('������Ч���ѹ�');
					} else {
						text = $g('������Ч�ڻ���'+ rowData.expDays +'��');
					}
					return '<label title="'+ text +'">'+ value +'</label>';
				}
			},
			BatNo: function(){
				var colClass = "pha-grid-a js-grid-batNo";
				QUE_COM.Grid.EventClassArr.push(colClass);	
				
				return function(value, rowData, rowIndex){
					if (!value){ return ""; }
					if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("�ϼ�") > -1)){
						return "";	
					}
					return QUE_COM.Grid._ColHtml(value, colClass);
				}
			},
			StkLimitState: function(){
				return function(value, rowData, index){
					var text = "";
					var bgcolor = "";
					if (value == "-1"){
						text = $g("��������");
						bgcolor = "#FF6565";
					} else if (value == "-2"){
						text = $g("��������");
						bgcolor = "gray";
					} else if (value == "-3"){
						text = $g("���ڱ�׼���");
						bgcolor = "#F1C516";
					}
					return QUE_COM.Grid._ColStateHtml(bgcolor, text);
				}
			},
			BtTips: function(){
				var colClass = "pha-grid-a js-grid-btTips icon icon-alert-red";
				QUE_COM.Grid.EventClassArr.push(colClass);
				return function(value, rowData, index){
					var value = rowData.btTips;
					if (value === ""){
						return value;
					}
					return ('<a class="'+ colClass +'" >&ensp;</a>');
				}
			},
			BizNo: function(){
				var colClass = 'pha-grid-a js-grid-bizNo';
				QUE_COM.Grid.EventClassArr.push(colClass);
				return function(value, rowData, index){
					if ((value === "") || (rowData.bizCode === "")){
						return value;
					}
					return QUE_COM.Grid._ColHtml(value, colClass);
				}
			},
			TransNo: function(){
				var colClass = 'pha-grid-a js-grid-TransNo';
				QUE_COM.Grid.EventClassArr.push(colClass);
				return function(value, rowData, index){
					if (value === ""){
						return value;
					}
					return QUE_COM.Grid._ColHtml(value, colClass);
				}
			}
		}
	},
	/**
	 * ���β��ɿ�ҽ��ԭ����ʾ����
	 */
	FormLcBtOrdTip: function(tip){
		switch (tip) {
			case "Expired"	:  	return $g("���ι���");
			case "NotEnough":   return $g("�������");
			case "OrdBan"	:  	return $g("����ҽ��������");
			case "StkBan"	:  	return $g("���ο�治����");
			case "Empty"	:  	return $g("�޿��ÿ��");
			case "OutLock"	:  	return $g("����ҩƷ�������");
			case "InLock"	:  	return $g("����ҩƷסԺ����");
			default			: 	return "";
		}
	},
	/**
	 * ���β��ɿ�ҽ��ԭ����ʾ
	 */
	LcBtOrdTips: function(tips){ 
		if (!tips){
			return "";	
		}
		var retTxtArr = [];
		var text = "";
		if(tips === "OutLock"){
			text = $g('���ﲻ�ɿ�ҽ��');
		} else if(tips === "InLock"){
			text = $g('סԺ���ɿ�ҽ��');
		} else {
			text = $g('���ɿ�ҽ��');
		}
		retTxtArr.push('<p style="font-weight:600;">'+ text +'</p>');
		retTxtArr.push('<div class="pha-line" style="margin:10px 0;"></div>');
		var tipArr = tips.split(",");
		for (var i = 0; i < tipArr.length; i++){
			retTxtArr.push('<p>'+ QUE_COM.FormLcBtOrdTip(tipArr[i]) +'</p>');
		}
		return retTxtArr.join("");
	}
}

function GetInciExpMonths(value){
	var date = $('#date').datebox('getValue');
	if (date == ""){
		var now = new Date();
		date = now.getFullYear() + "-" + (now.getMonth() + 1) + "-" + now.getDate();
	}
	// ���������
	valueArrs = value.split('-');
	dateArrs = date.split('-');
	// �õ�����
	expMonths = parseInt(valueArrs[0]) * 12 + parseInt(valueArrs[1]);
	dateMonths = parseInt(dateArrs[0]) * 12 + parseInt(dateArrs[1]);
	var expMonths = expMonths - dateMonths;
	if (expMonths < 0) {
		expMonths = 0;
	}
	return expMonths;
}

function GetDaysForDateByDate(dateTo){
	var dateFr = $('#date').datebox('getValue');
	if (dateFr == ""){
		var dateFr = new Date();
	}
	dateFr = new Date(dateFr + " 00:00:00"); 
	var dateTo = new Date(dateTo + " 00:00:00"); //���ù�ȥ��һ��ʱ��㣬"yyyy-MM-dd HH:mm:ss"��ʽ������
	var difftime = (dateTo - dateFr) / 1000; 		//����ʱ���,���Ѻ���ת������
	var days = parseInt(difftime / 86400); 
	return days;
}

function MergeRetData(gridID, idField, fieldArr){
	if ((fieldArr.length === 0) || (idField === "") || (gridID === "")){
		return;	
	}
	var rows = $('#'+ gridID).datagrid('getRows');
	if (rows.length === 0){
		return;	
	}
	var rowNum = 1;
	for (var i = 1; i < rows.length; i++){
		if (rows[i - 1][idField] === rows[i][idField]){
			rowNum++; 
		} else {
			MergeCells(gridID, fieldArr, i - rowNum, rowNum);
			rowNum = 1;
		}
	}
	MergeCells(gridID, fieldArr, (rows.length - rowNum), rowNum);
}

function MergeCells(gridID, fieldArr, rowIndex, rowspanNum){
	if ((fieldArr.length === 0) || (rowIndex === "")){
		return;	
	}
	for (var j = 0; j < fieldArr.length; j++){
		$('#'+ gridID).datagrid('mergeCells', {
			index: rowIndex,
			field: fieldArr[j],
			rowspan: rowspanNum,
			colspan: 0
		});
	}
}