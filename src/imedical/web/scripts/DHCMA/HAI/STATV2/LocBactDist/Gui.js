function InitLocBactDistWin(){
	var obj = new Object();
	$.parser.parse();
	LogonHospID=$.LOGON.HOSPID;
	obj.SpecDr = "";
	obj.SpecDesc   = "";
	obj.TypeCode="";
	// 日期赋初始值
	var YearList = $cm ({									//初始化年(最近十年)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var MonthList = $cm ({									//初始化月+季度+全年
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//更改开始-结束日期
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//当前年
	var NowMonth=NowDate.split("-")[1]	//当前月
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
	//医院
	Common_ComboToMSHosp("cboHospital",$.LOGON.HOSPID);
	$HUI.combobox("#cboHospital",{
		onSelect:function(rec){//给医院增加Select事件，更新科室列表
			var HospIDs=$('#cboHospital').combobox('getValues').join('|');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Common_CheckboxValue('chkStatunit');
			//科室病区
			Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
		}
	});
	
	obj.cboInfType = $HUI.combobox("#cboInfType", {
		url:$URL,
		editable: true,
		allowNull: true, 
		valueField: 'ID',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCHAI.BTS.DictionarySrv';
			param.QueryName = 'QryDic';
			param.aTypeCode = 'IRInfType';
			param.aActive = 1;
			param.ResultSetType = 'array';
		},onSelect:function(rec){//给医院增加Select事件，更新科室列表
			obj.TypeCode=rec.DicCode;
		}
	});
	$HUI.radio("[name='chkStatunit']",{
        onChecked:function(e,value){
	        var Statunit = $(e.target).val();   //当前选中的值
			var HospIDs =  $("#cboHospital").combobox('getValues').join('|');
			var Alias   = "";
			var LocCate = "I";
			var LocType = Statunit;
	        setTimeout(function(){
		      	//科室病区
				Common_ComboToMSLoc("cboLoc",HospIDs,"","I",LocType);
			 }, 200);
        }
    });
    $HUI.radio("#chkStatunit-Ward").setValue(true);
    //初始化科室
	Common_ComboToMSLoc("cboLoc",$('#cboHospital').combobox('getValues').join('|'),"","I",Common_CheckboxValue('chkStatunit'));
    obj.cboSpec = $HUI.lookup("#cboSpec", {
		url:$URL,
		panelWidth:300,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		isValid:true,
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:0,             //isCombo为true时，可以搜索要求的字符最小长度
		valueField: 'ID',
		textField: 'SpecDesc',
		queryParams:{ClassName: 'DHCHAI.DPS.LabSpecSrv',QueryName: 'QryLabSpecimen',aAlias:"",aActive:"1"},
		columns:[[  
			{field:'SpecDesc',title:'标本',width:280}  
		]],
		onBeforeLoad:function(param){
			var desc=param['q'];
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
			if (desc==""){
				obj.SpecDr = "";
				obj.SpecDesc = "";
			}
		},
		onSelect:function(index,rowData){ 
			obj.SpecDr = rowData.ID;
			obj.SpecDesc = rowData.SpecDesc;	
		}
	});
	//默认耐药级别
	$HUI.combobox("#cboDrugLevel",{
		data:[{Id:'1',text:'多耐'},{Id:'2',text:'敏感'}],
		valueField:'Id',
		textField:'text'
	});
	//默认耐药级别
	$HUI.combobox("#cboStatNum",{
		data:[{Id:'1',text:'5',selected:true},{Id:'2',text:'10'},{Id:'3',text:'15'},{Id:'4',text:'20'}],
		valueField:'Id',
		textField:'text'
	});
	//默认日期类型
	$HUI.combobox("#cboDateType",{
		data:[{Id:'1',text:'送检日期',selected:true},{Id:'2',text:'报告日期'}],
		valueField:'Id',
		textField:'text'
	});	
	
	InitFloatWin(obj);
	InitLocBactDistWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
