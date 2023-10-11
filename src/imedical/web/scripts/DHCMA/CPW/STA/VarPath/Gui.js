//页面Gui
function InitWin(){
	var obj = new Object();
    $.parser.parse(); 
	
	//初始查询条件
    obj.cboHospital = Common_ComboToSSHosp2("cboHospital",session['DHCMA.HOSPID'],"CPW");
	//医院科室联动
	$HUI.combobox('#cboHospital',{
	    onSelect:function(rows){
		    var HospID=rows["OID"];
		    Common_ComboToLoc3("cboLocation","E","","I",HospID);
		    $HUI.combobox("#cboPathMast", {
				url: $URL,
				editable: true,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'BTID',
				textField: 'BTDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCMA.CPW.BTS.PathMastSrv';
					param.QueryName = 'QryRepPathMast';
					param.aHospID = HospID;
					param.aAdmType='I';
					param.ResultSetType = 'array';
				}
			});
	    }
    });
    
    // 日期赋初始值
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCMA.CPW.STAS.DateUtil",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","DateFrom","DateTo");	//更改开始-结束日期
		}
	});
	var MonthList = $cm ({									//初始化月+季度+全年
		ClassName:"DHCMA.CPW.STAS.DateUtil",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","DateFrom","DateTo");	//更改开始-结束日期
		}
	});
    var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
	
	
	InitWinEvent(obj);	
	return obj;
}