//页面Gui
var obj = new Object();
function InitHISUIWin(){
	obj.selVerID = "";
	obj.selVerEpID = "";
	obj.ItemRowData = null;
	obj.PathFormSympDr = "";
	obj.cboHospValue=session['DHCMA.HOSPID'];
	obj.DescSearch="";
	//当前表单版本信息
	obj.CurrForm = new Object();
	obj.CurrForm.ID       = "";
	obj.CurrForm.PathDesc = "";
	obj.CurrForm.Version  = "";
	obj.CurrForm.IsActive = 0;
	obj.CurrForm.IsOpen   = 0;
	
	obj.cbokind = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: true,
		defaultFilter:"4",
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTypeSrv';
			param.QueryName = 'QryPathType';
			param.ResultSetType = 'array'
		}
	});
	//病种路径
	obj.cboPath = $HUI.combobox('#cboEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathEntitySrv';
			param.QueryName = 'QryPathEntity';
			param.aIsActive = '1';
			param.ResultSetType = 'array'
		}
	});
	//病种付费
	obj.cboPay = $HUI.combobox('#cboPCEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'RowID',
		textField: 'Desc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.PCEntitySrv';
			param.QueryName = 'QryPCEntity';
			param.aIsActive = '1';
			param.ResultSetType = 'array'
		}
	});
	//病种质量
	obj.cboQuality = $HUI.combobox('#cboQCEntityDr', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		defaultFilter:"4",
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.SDS.QCEntitySrv';
			param.QueryName = 'QryQCEntity';
			param.ResultSetType = 'array'
		}
	});
	
	obj.LocID=session['DHCMA.CTLOCID'];
	
	if(tDHCMedMenuOper['admin']>0) obj.LocID=0;
	
	//加载树内容
	obj.LoadPathTree =  function (AdmType)  {
		$('#treeType').tree({
			url:$URL+"?ClassName=DHCMA.CPW.BTS.PathFormSrv&QueryName=QryLocPathVer&argNodeID=-root&argLocID="+obj.LocID+"&argAdmType="+AdmType+"&argHospID="+obj.cboHospValue+"&argDesc="+""+"&argKeyWords="+""+"&ResultSetType=array"	
			,onLoadSuccess:function(node,data)
			{
				//回调
			}
		});	
	}
	
	//中药方剂维护-弹出窗体初始化
	$('#winPathFormSympEdit').dialog({
		title: '方剂证型维护',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true
	});
	
	//方剂证型维护-中药方剂加载
	obj.cboSympTCM = $HUI.combobox('#cboSympTCM', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		//defaultFilter:"4",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathTCMSrv';
			param.QueryName = 'QryPathTCM';
			param.ResultSetType = 'array';
			param.aWay="droplist"
		}
	});
	//方剂证型维护-路径版本加载
	obj.cboPathForm = $HUI.combobox('#cboPathForm', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'FormID',
		textField: 'FormVerDesc',
		//defaultFilter:"4",
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathFormSrv';
			param.QueryName = 'QryPathForm';
			param.ResultSetType = 'array';
			param.aPathMastDr = $("#pathMastID").val();
		}
	});
	
	//方剂证型维护-中医症候维护
	obj.cboSympDiagnos = $HUI.combobox('#cboSympDiagnos',{
		url:$URL,
		valueField: 'SympDiaID',
		textField: 'SympDiaDesc',
		multiple:true,  //多选
		mode: 'remote',
		rowStyle:'checkbox',
		selectOnNavigation:false,
		editable: false,
		onBeforeLoad: function (param) {
			/*
			var panel=$("#cboSympDiagnos").combo('panel');
			var preHtml="<input class=\"textbox\" id=\"txtSearch\" placeholder=\"  输入查询内容\" style=\"width:99%;\" οnkeyup=\"$(this).load()\" />";
			$(preHtml).prependTo($(panel).parent("div"));
			*/
			param.ClassName = 'DHCMA.CPW.BTS.PathFormSympSrv';
			param.QueryName = 'QuerySetPattern';
			param.ResultSetType = 'array';
			param.aAlias = $("#cboSympDiagnos").combobox('getText');
		},
		onShowPanel:function(){
			obj.cboSympDiagnos.reload();	
		}
	})
	//证型搜索
	obj.cboSearchKey = $HUI.combobox('#cboSearchKey',{
		url: $URL,
		editable: true,
		defaultFilter:"4",
		//multiple:false,  //多选
		//mode: 'remote',
		//rowStyle:'checkbox',
		valueField: 'SympDiaID',
		textField: 'SympDiaDesc',
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathFormSympSrv';
			param.QueryName = 'QuerySetPattern';
			param.ResultSetType = 'array';
			param.aAlias = '';
		},
		onSelect:function(row){
			//alert(row.SympDiaID+","+row.SympDiaDesc)
			var SympDiagnos = obj.cboSympDiagnos.getValues();
			var SympDiagnosDesc = obj.cboSympDiagnos.getText();
			var ret = SympDiagnos.indexOf(row.SympDiaID);
			if(ret>-1){
				$.messager.alert("提示","路径方剂已存在"+row.SympDiaDesc+"！");
			}
			
			SympDiagnos.push(row.SympDiaID);
			obj.cboSympDiagnos.setValues(SympDiagnos);
			if (SympDiagnosDesc==""){
				obj.cboSympDiagnos.setText(row.SympDiaDesc);
			}else{
				obj.cboSympDiagnos.setText(SympDiagnosDesc+","+row.SympDiaDesc);	
			}
			
			$("#cboSearchKey").combobox('setValue',"");
		}
	})
	
	obj.cboHosp = $HUI.combobox('#cboHosp', {
		url: $URL,
		editable: false,
		multiple:true,
		selectOnNavigation:false,
		mode: 'remote',
		valueField: 'OID',
		textField: 'Desc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.EPS.HospitalSrv';
			param.QueryName = 'QryHospInfo';
			param.ResultSetType = 'array';
		}
		,formatter:function(row){  
			var opts;
			if(row.selected==true){
				opts = "<input type='checkbox' checked='checked' id='r"+row.OID+"' value='"+row.OID+"' style='vertical-align:middle;margin-right: 3px;'>"+row.Desc;
			}else{
				opts = "<input type='checkbox' id='r"+row.OID+"' value='"+row.OID+"' style='vertical-align:middle;margin-right: 3px;'>"+row.Desc;
			}
			return opts;
		},
		onSelect:function(rec) {
			var objr =  document.getElementById("r"+rec.OID);
			$(objr).prop('checked',true);
			obj.cboHospValue=obj.cboHospValue+"^"+rec.OID;
		}
		,onUnselect:function(rec){
			var objr =  document.getElementById("r"+rec.OID);
			$(objr).prop('checked',false);
			var subStr="^"+rec.OID;
			obj.cboHospValue=obj.cboHospValue.replace(subStr,"");
		}
	});
	
	$('#DescSearch').searchbox({ 
		searcher:function(value){
			obj.DescSearch=value;
			SearchPath();
		}
	}); 
	
	$("#kwSearch").keywords({
        singleSelect:false,
        labelCls:'blue',
	    items:[{
                text:"特征", 
                type:"section",
                items:[
                    {text:'无效',id:'NotActive'},
			        {text:'未发布',id:'NotOpen'},
			        {text:'无单病种',id:'NotEntity'},
			        {text:'未关联科室',id:'NotLinkLoc'},
			        {text:'无准入信息',id:'NotDiag'},
			        {text:'无适用文档',id:'NotDoc'},
			        {text:'有方剂证型',id:'NotSymp'},
			        {text:'未关联医嘱',id:'NotOrder'},
			        {text:'无参考天数',id:'NotDays'},
			        {text:'无参考费用',id:'NotFees'},
			        {text:'无付费病种',id:'NotPCEntity'},
			        {text:'无质控病种',id:'NotQCEntity'},
			        {text:'无人入径',id:'NotFees'}
                ]
            }
	        
	    ],
	    onClick:function(v){},
	    onUnselect:function(v){},
	    onSelect:function(v){
			
		}
	});
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
