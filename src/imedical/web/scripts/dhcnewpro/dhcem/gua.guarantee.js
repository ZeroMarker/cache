///CreatDate:  2018-07-09
///Author:     zhouxin
/// gua.guarantee.js 
$(function(){
	initCombox();
	initBtn();
	GetLgContent();
	initInputEvent();
	initDefaultValue();
	initDataGrid();
	searchAction();	
});

function initCombox(){
	//担保原因
	$('#guaReason').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocGuarantee&MethodName=reasonCombox&hosp='+LgHospID,
		valueField: 'id',
		textField: 'text',
		editable:false
	})
	//担保金额
	$('#guaranteeAmt').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocGuaLevel&MethodName=levelCombox&hosp='+LgHospID,
		valueField: 'id',
		textField: 'text',
		editable:false
	})
	//担保状态
	$('#status').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocGuarantee&MethodName=statusCombox',
		valueField: 'id',
		textField: 'text',
		editable:false,
		onSelect:function(org){
			searchAction();
		}
	})
	
	
	//担保人
	$('#guausers').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocGuarantee&MethodName=getGuaUser&LgHospID='+LgHospID, //hxy 2020-06-15 LgHospID
		valueField: 'value',
		textField: 'text',
		mode:'remote'
	})
	//证件类型
	$('#mortgages').combobox({
		url:'dhcapp.broker.csp?ClassName=web.DHCEMPatCheckLevCom&MethodName=GetCertTypelList',
		valueField: 'value',
		textField: 'text',
		blurValidValue:true,
		editable:false
	})
		
}
function initBtn(){
	 $('#addBTN').on('click',function(){addAction("add")})
	 $("#searchBTN").on('click',function(){searchAction()})
	 $("#auditBTN").on('click',function(){auditGua("Y")})
	 $("#refuseBTN").on('click',function(){auditGua("N")})
	 $("#cancelBTN").on('click',function(){auditGua("C")})
	 $("#updateBTN").on('click',function(){addAction("update")})
	 $("#printBTN").on('click',function(){printAction()})
	 //$("#itmsSelBTN").on('click',function(){itmsSelAction()}) 
}
/// 取登录信息
function GetLgContent(){

	runClassMethod("web.DHCEMAdvPayass","GetLgContent",{"LgLocID":LgCtLocID,"LgUserID":LgUserID},function(jsonObject){
		
		if (jsonObject != null){
			$('#guaUser').val(jsonObject.User);  /// 担保人
		}
	},'json',false)
}
/*function itmsSelAction() {
	$('#itmsDlg').show();
	var itmsDlgObj = $HUI.dialog('#itmsDlg', {
		title: '抵押物',
		draggable: false,
		resizable: true,
		modal: true,
		buttons: [{
				text: '确认',
				handler: function () {
					var itemAry = new Array();
					$('#items').find('tbody').each(function () {
						$(this).find('tr').each(function () {
							$(this).find('td').each(function () {
								if ($(this).find('input').checkbox('getValue')) {
									itemAry.push($(this).find('input').attr('label'));
								}
							});
						});
					});
					var items = itemAry.join();
					$('#mortgages').val(items);
					itmsDlgObj.close();
				}
			}, {
				text: '关闭',
				handler: function () {
					itmsDlgObj.close();
				}
			}
		]
	});
}*/
//新增担保
function addAction(type){
	
	guaranteeId=$('#guaranteeId').val()
	if((type=="update")&&(guaranteeId=="")){
		$.messager.alert('提示','请选择一条数据!');
		return;
	}

	if($('#detailTable').form('validate')){
		
		if(type=="add"){
			guaranteeId="";
		}
		$.ajax({
	     	type: "POST",
	     	url: LINK_CSP,
	     	data: {
				'ClassName':'web.DHCEMDocGuarantee',
				'MethodName':'saveGuarantee',
				'guaranteeAmt':$('#guaranteeAmt').combobox('getValue'),
				'guaReason':$('#guaReason').combobox('getValue'),
				'startDate':$('#guaStartDate').datebox('getValue'),
				'endDate':$('#guaEndDate').datebox('getValue'),
				'mortgages':$('#mortgages').combobox('getValue'),
				'guaUser':$('#guaUser').val(),
				'lgUser':LgUserID,
				'adm':$('#EpisodeID').val(),
				'guaranteeId':guaranteeId
		 	},
	     	dataType: "json",
	    	success: function(data){
		     		if(data.code==0){
			     		$.messager.alert('提示','保存成功!')
						searchAction();
					}else{
						$.messager.alert('提示','保存失败:'+data.msg)		
					}
		     }
		 });
	 }
}
function initDataGrid(){
	$('#datagrid').datagrid({
		title:'申请列表',
		iconCls:'icon-paper',/*hxy 2022-11-22*/
		headerCls:'panel-header-gray',
		rownumbers:true,	
		pagination:true,
		toolbar:'#toolbar',
		singleSelect:true,
		fitColumns:true,
		fit:true,
		onLoadSuccess: function(data){
			if($('#GrossClass').val()==1){
				if(data.total>0){
					$('#datagrid').datagrid("selectRow",0);
					getInfoByGua(data.rows[0].ID,data.rows[0].adm);
				}else{
					alearPanel();
				}
			}
		},
		onBeforeLoad:function(param){
			param.parAdm=getAdm();
	    	param.no=$("#regno").val();
	    	param.startDate=$("#startDate").datebox('getValue');
	    	param.endDate=$("#endDate").datebox('getValue');
	    	param.status=$("#status").combobox('getValue');
	    	param.grossClass=$("#GrossClass").val();
	    	param.lgUser=LgUserID;
	    	param.lgHosp=LgHospID; //hxy 2020-06-15
	    	param.guaUser=$("#guausers").combobox('getValue');
			return param;
		},
	    url:'dhcapp.broker.csp?ClassName=web.DHCEMDocGuarantee&MethodName=ListGuarantee',
	    onClickRow:function(index, row){getInfoByGua(row.ID,row.adm)},
	    columns:[[
	        {field:'ID',title:'ID',hidden:true},
	        {field:'adm',title:'adm',hidden:true},
	        {field:'regno',title:'登记号',width:50},
	        {field:'name',title:'姓名',width:50},
	        {field:'sex',title:'性别',width:30},
	        {field:'age',title:'年龄',width:30},
	        {field:'amt',title:'申请担保金额',width:30},
	        {field:'reqUser',title:'担保人',width:30},
	        {field:'reqDate',title:'申请时间',width:50},
	        {field:'admLoc',title:'就诊科室',width:50},
	        {field:'auditState',title:'申请状态',width:30},
	        {field:'auditUser',title:'审批人',width:30},
	        {field:'refuseReason',title:'拒绝原因',width:50}
	    ]]
	});
}
function initDefaultValue(){
	
	hosNoPatOpenUrl = getParam("hosNoPatOpenUrl"); //hxy 2023-03-15 st
	hosNoPatOpenUrl?hosOpenPatList(hosNoPatOpenUrl):''; //ed
	
	nowDay=new Date()
	date=nowDay.Format('YYYY-MM-dd')
	start=new Date((nowDay.getTime()-30*24*60*60*1000)).Format('yyyy-MM-dd')
	$("#startDate").datebox('setValue',start)	
	$("#endDate").datebox('setValue',date)
	$("#guaStartDate").datebox('setValue',date)
	adm=getAdm();
	var GrossClass=$("#GrossClass").val(); //总值班标志
	var PatientID=$("#PatientID").val();
	if(GrossClass==1){
		 //总值班
		 $("#addBTN").linkbutton('disable');
		 $("#updateBTN").linkbutton('disable');
		 $("#cancelBTN").linkbutton('disable');
		 $("#status").combobox('setValue','R');
		 $("#addBTN").unbind("click");
		 $("#updateBTN").unbind("click");
		 $("#cancelBTN").unbind("click");
		 if(PatientID!=""){
		 	RegNo=serverCall("web.DHCEMDocGuarantee","getRegNoByPatientID",{PatientID:PatientID});
		 	$("#regno").val(RegNo)
		 }
		 searchAction();
	}else{
	    $("#auditBTN").linkbutton('disable');
		$("#refuseBTN").linkbutton('disable')
		$('#auditBTN').unbind("click");
		$('#refuseBTN').unbind("click"); 
		if(adm==""){
			$.messager.alert('警告','请选择就诊记录');
			return;
		}
		getInfoBYAdm(adm)
		searchAction();
	}
	
	$.ajax({
     	url: LINK_CSP,
     	data: {
			'ClassName':'web.DHCAppComPar',
			'MethodName':'GetAppPropValue',
			'AppCode':'DHCGUA',
			'FunCode':'GREENSWITCH',
			'Hosp':LgHospID,
			'Loc':LgCtLocID,
			'User':LgUserID,
			'Group':LgGroupID,
	 	},
     	dataType: "text",
    	success: function(data){
			if(data!=1){
				$("#addBTN").linkbutton('disable');
			 	$("#updateBTN").linkbutton('disable');
			 	$("#cancelBTN").linkbutton('disable');
			 	$("#addBTN").unbind("click");
			 	$("#updateBTN").unbind("click");
			 	$("#cancelBTN").unbind("click");
			}
	     }
	 });
	
	
}
function getInfoBYAdm(adm){
		$("#EpisodeID").val(adm);
		$.ajax({
	     	url: LINK_CSP,
	     	data: {
				'ClassName':'web.DHCEMDocGuarantee',
				'MethodName':'getInfoBYAdm',
				'adm':adm,
				'hosp':LgHospID,
		 	},
	     	dataType: "json",
	    	success: function(data){
		    	if(data.admType!="A"){
			    	if(data.admType=="P"){
				    	$("#admTypeMessage").html($g("患者非住院状态")+"！"+$g("禁止申请")+"！");
				    }else if (data.admType=="D"){
					    $("#admTypeMessage").html($g("患者已离院")+"！"+$g("禁止申请")+"！");
					}else if (data.admType=="C"){
					    $("#admTypeMessage").html($g("患者已退号")+"！"+$g("禁止申请")+"！");
					}else{
			    		$("#admTypeMessage").html($g("患者非正常就诊状态")+"！"+$g("禁止申请")+"！");
					}
			    	$("#addBTN").linkbutton('disable');
			    	$('#addBTN').unbind("click");
			    }
			    if(data.admCat=="I"){
					$(".inItm").show();
					$(".emItm").hide();	
				}else{
					$(".inItm").hide();
					$(".emItm").show();		
				}
				$("#name").val(data.name)
				$("#sex").val(data.sex)
				$("#age").val(data.age)
				$("#level").val(data.level)
				$("#admway").val(data.admway)
				$("#admtime").val(data.admtime)
				$("#threenon").val(data.threenon)
				$("#diagnosis").val(data.diagnosis)
				$("#inHospDate").val(data.inHospDate);
		     }
		 });	
}

function alearPanel(){
	$("#name").val("")
	$("#sex").val("")
	$("#age").val("")
	$("#level").val("")
	$("#admway").val("")
	$("#admtime").val("")
	$("#threenon").val("")
	$("#diagnosis").val("")
	$("#mortgages").combobox('setValue',"")
	$("#guaranteeAmt").combobox('setValue',"")
	$("#guaStartDate").datebox('setValue',"")
	$("#guaEndDate").datebox('setValue',"")
	$("#guaReason").combobox('setValue',"")
	$("#guaUser").val("");
	return;
}


function searchAction(){
	$('#datagrid').datagrid('load')
}

function getAdm(){
	try{
		adm="";
		/*var frm=window.opener.document.forms["fEPRMENU"]; //hxy 2023-03-15 st hos不能带患者信息
		if(frm.EpisodeID){
			adm=frm.EpisodeID.value;
		}else{
			adm=$("#EpisodeID").val()
		}*/
		if(window.opener){
			var frm=window.opener.document.forms["fEPRMENU"];
			if(frm.EpisodeID){
				adm=frm.EpisodeID.value;
			}
		}else{
			adm=$("#EpisodeID").val();
		} //ed
		
		return adm
	}catch(e){
		return "";
	}
}
function getInfoByGua(gua,adm){
	$("#guaranteeId").val(gua)
	$("#EpisodeID").val(adm)
	getInfoBYAdm(adm);
	$.ajax({
     	url: LINK_CSP,
     	data: {
			'ClassName':'web.DHCEMDocGuarantee',
			'MethodName':'getInfoBYGua',
			'gua':gua
	 	},
     	dataType: "json",
    	success: function(data){
			$("#mortgages").combobox('setValue',data.mortgages)
			$("#guaranteeAmt").combobox('setValue',data.guaranteeAmt)
			$("#guaStartDate").datebox('setValue',data.guaStartDate)
			$("#guaEndDate").datebox('setValue',data.guaEndDate)
			$("#guaReason").combobox('setValue',data.guaReason)
			$("#guaUser").val(data.guaUser);
			/*$HUI.checkbox("input[id^='WarrantItem']").setValue(false);
			if (data.mortgages != ""){    /// 点击申请后赋值 2019-08-19 bianshuai
				var itemArr = data.mortgages.split(",");
				for (var i=0; i<itemArr.length; i++){
					$HUI.checkbox('[label="'+ itemArr[i] +'"]').setValue(true);
				}
			}*/
	     }
	 });
}

function auditGua(state){
	 gua=$("#guaranteeId").val()
	 if(gua==""){
		 $.messager.alert('警告','请选择要操作的记录');
		 return;	
	 }
	 var row=$('#datagrid').datagrid('getSelected');
	 if(row==null){
		 $.messager.alert('警告','请选择要操作的记录');
		 return;	
	 }
	 if(row.auditState == $g("取消申请")){
		 var message = (state == "C"?$g("该记录已取消申请")+"，"+$g("无需再次取消申请")+"!":$g("该记录已取消申请")+"，"+$g("不能进行该操作")+"!");
		 $.messager.alert('警告',message,'warning');
		 return;	
	 }
	 var rowDataAdm=row.adm;	///获取选中行的就诊ID	

	 if(state=="Y"){ msg="确认要审批通过吗"};
	 if(state=="N"){ msg=$g("确认要拒绝审批通过吗")+"？<br>"+$g("拒绝原因")+"<br><textarea id='refuseReason' style='width:197px'/>"};
	 if(state=="C"){ msg="确认要取消申请吗"};
	 window.parent.$.messager.confirm('提示', msg, function(r){
		if (r){
			    reason=""
			    if(state=="N"){
				    reason=$('#refuseReason').val();
				    if(reason==""){
					    $.messager.alert('警告','原因不能为空');
				    	return;
					}

				}
				$.ajax({
			     	url: LINK_CSP,
			     	data: {
						'ClassName':'web.DHCEMDocGuarantee',
						'MethodName':'auditGua',
						'gua':gua,
						'state':state,
						'lgUser':LgUserID,
						'guaReason':reason
				 	},
			     	dataType: "json",
			    	success: function(data){
						if(data.code==0) {
							searchAction();
							//+2018-07-17 ZhYW 刷新计费组界面
							setTimeout(function() {
								websys_showModal("options").callbackFunc(rowDataAdm);
								websys_showModal("close");
							}, 200);
						}else{
							$.messager.alert('警告','失败：'+data.msg);	
						}
				    }
				 });
		}
	});
}
function initInputEvent(){
	$('#regno').on('keypress', function(e){   
		// 监听回车按键   
		e=e||event;
		if(e.keyCode=="13"){
			var regNo = $('#regno').val();
			 
			if(regNo==""){
				$.messager.alert("提示:","登记号为空");    
				return;
			}
			 
			var m_lenght =serverCall("web.DHCCLCom","GetPatConfig",{}).split("^")[0] 
			///登记号补0
			for (i=regNo.length;i<m_lenght;i++){
				regNo = "0"+regNo;
			}	
			$('#regno').val(regNo);
			searchAction();	
		}
	});
}
//打印
function printActionBak(){
	
	gua=$("#guaranteeId").val()
	if(gua==""){
		 $.messager.alert('警告','请选择要操作的记录');
		 return;	
	}
	try {
		var ret=serverCall("web.DHCEMDocGuarantee","getPrintInfo",{gua:gua}).split("^")
		if (ret[8] == "C"){
			$.messager.alert('警告','当前申请已取消不允许打印!','warning');
		 	return;	
		}
		//alert(ret)
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_GUA");
		var PatName=ret[2];      //姓名
		var Company=ret[3]       //单位 
		var Phone=ret[4]         //电话 
		var Address=ret[6]       //地址 
		var Diagnosis=ret[5]     //诊断
		var Guarantee=ret[0];    //抵押物
		var GuaranteeAmt=ret[1]; //抵押金额
		var HospName=ret[7]
		 
		var MyPara="HospName"+String.fromCharCode(2)+HospName
		var MyPara=MyPara+"^PatName"+String.fromCharCode(2)+PatName
		var MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company
		var MyPara=MyPara+"^Phone"+String.fromCharCode(2)+Phone
		var MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address
		var MyPara=MyPara+"^Diagnosis"+String.fromCharCode(2)+Diagnosis
		var MyPara=MyPara+"^Guarantee"+String.fromCharCode(2)+Guarantee
		var MyPara=MyPara+"^GuaranteeAmt"+String.fromCharCode(2)+GuaranteeAmt
		//alert(MyPara)
		var myobj=document.getElementById("ClsBillPrint");
		DHCP_PrintFunHDLP(myobj,MyPara,""); //DHCP_PrintFun
	} catch(e) {alert(e.message)};
}	



//打印
function printAction(){
	
	gua=$("#guaranteeId").val()
	if(gua==""){
		 $.messager.alert('警告','请选择要操作的记录');
		 return;	
	}
	try {
		var ret=serverCall("web.DHCEMDocGuarantee","getPrintInfo",{gua:gua}).split("^")
		if (ret[8] == "C"){
			$.messager.alert('警告','当前申请已取消不允许打印!','warning');
		 	return;	
		}
		var LODOP = getLodop();
		LODOP.PRINT_INIT("CST PRINT");
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCEM_GUA");
		var PatName=ret[2];      //姓名
		var Company=ret[3]       //单位 
		var Phone=ret[4]         //电话 
		var Address=ret[6]       //地址 
		var Diagnosis=ret[5]     //诊断
		var Guarantee=ret[0];    //抵押物
		var GuaranteeAmt=ret[1]; //抵押金额
		var HospName=ret[7]

		var Regno=ret[9]; // 登记号
		var GuaStartDate=ret[10]; // 担保开始日期
		var GuaEndDate=ret[11]; // 担保结束日期
		 
		var MyPara="HospName"+String.fromCharCode(2)+HospName
		var MyPara=MyPara+"^PatName"+String.fromCharCode(2)+PatName
		var MyPara=MyPara+"^Company"+String.fromCharCode(2)+Company
		var MyPara=MyPara+"^Phone"+String.fromCharCode(2)+Phone
		var MyPara=MyPara+"^Address"+String.fromCharCode(2)+Address
		var MyPara=MyPara+"^Diagnosis"+String.fromCharCode(2)+Diagnosis
		var MyPara=MyPara+"^Guarantee"+String.fromCharCode(2)+Guarantee
		var MyPara=MyPara+"^GuaranteeAmt"+String.fromCharCode(2)+GuaranteeAmt
		var MyPara=MyPara+"^Regno"+String.fromCharCode(2)+Regno
		var MyPara=MyPara+"^GuaStartDate"+String.fromCharCode(2)+GuaStartDate
		var MyPara=MyPara+"^GuaEndDate"+String.fromCharCode(2)+GuaEndDate


		DHC_CreateByXML(LODOP,MyPara,"",[],"PRINT-CST-NT");  //MyPara 为xml打印要求的格式
		var printRet = LODOP.PRINT();
	} catch(e) {alert(e.message)};
}
