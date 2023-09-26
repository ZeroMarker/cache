var PageLogicObj={
	m_selARCOSRowId:"",
	m_AddTOArcosARCIMDatas:"",
	pattern:new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]") 
}
$(function(){
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
})
function InitEvent(){
	$("#BAddARCOS").click(BAddARCOSClickHandle);
	$("#BAddTabName").click(BAddTabNameClick);
	$("#BAddTemplGroup").click(BAddTemplGroupClick);
	//新增模板组 保存
	$("#BSaveGroup").click(BSaveGroupClickHandle);
	//新增模板子表 保存
	$("#BSaveTabName").click(BSaveTabNameClickHandle);
	$("#BSave").click(BSaveClickHandle);
	$("#ARCOSName").change(ARCOSNameChange);
}
function PageHandle(){
	var obj = window.dialogArguments;
	if (obj) {
		PageLogicObj.m_AddTOArcosARCIMDatas=obj.name;
	}else{
		PageLogicObj.m_AddTOArcosARCIMDatas=websys_showModal("options").paraObj.name;
	}
	InitARCOSLookup();
	InitTempl();
}
function BAddARCOSClickHandle(){
	$(".arcosnew").show();
	InitAddArocsCom();
}
function BAddTabNameClick(){
	$("#AddTabName-tr").show();
	$("#TemplTabNameDesc").val('').focus();
}
function BAddTemplGroupClick(){
	$("#AddGroup-tr").show();
	$("#TemplGroupDesc").val('').focus();
}
function InitARCOSLookup(){
	$("#ARCOS").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ArcimDr',
        textField:'ARCOSName',
        columns:[[  
            {field:'ArcimDr',title:'',hidden:true},
			{field:'ARCOSName',title:'医嘱套名称',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
		panelHeight:310,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpARCOS'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{ARCOS:desc});
	    },
	    onSelect:function(index, rec){
		    PageLogicObj.m_selARCOSRowId=rec["ArcimDr"];
		}
    });
}
function InitAddArocsCom(){
	InitCategory();
	InitConditiones();
}
function InitCategory(){
	$.cm({
		ClassName:"web.UDHCFavItemNew", //web.OECOrderCategory
		QueryName:"CombListFind", //LookUpCat
		CombName:"Category",
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#Category", {
				valueField: 'CombValue', //HIDDEN
				textField: 'CombDesc',  //catDesc
				disabled:true,
				data: Data['rows'],
				onSelect:function(rec){
					InitSubCategory(rec['CombValue']);
				}
		 });
		 for (var i=0;i<Data['rows'].length;i++){
			 if (Data['rows'][i]['CombDesc'].indexOf("医嘱套")>=0){
				 $("#Category").combobox('select',Data['rows'][i]['CombValue']);
				 break;
			 }
		 }
	});
}
function InitSubCategory(CategoryId){
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"SubCategory",Inpute1:CategoryId,
		rows:99999
	},function(Data){
		var cbox = $HUI.combobox("#SubCategory", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:false,
				data: Data['rows'],
				onSelect:function(rec){
					$("#ARCOSName").focus();
				}
		 });
	});
}
function InitConditiones(){
	$HUI.combobox("#Conditiones", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: [{"id":1,"text":"个人"},{"id":2,"text":"科室"},{"id":3,"text":"全院"}]
	 });
}
function InitTempl(){
	InitTemplCategory();
}
function InitTemplCategory(){
	var dataArr=new Array();
	dataArr.push({"id":"User.SSUser","text":"个人"});
	if(ServerObj.MenuAuthOrderOrgFav==1){
		dataArr.push({"id":"User.CTLoc","text":"科室"});
	}
	$HUI.combobox("#TemplCategory", {
			valueField: 'id',
			textField: 'text', 
			editable:false,
			data: dataArr,
			onSelect:function(rec){
				InitTemplTabName(rec['id'],"");
			},
			onLoadSuccess:function(){
				$(this).combobox('select','User.SSUser');
			}
	 });
}
//模板组
function InitTemplTabName(ObjectType,defTabName){
	$.cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"GetTabNameListBroker",
		JSFunName:"GetTabNameToHUIJson", ListName:"", UserID:session['LOGON.USERID'], Type:ServerObj.Type,
		CTLOCID:session['LOGON.CTLOCID'], XCONTEXT:ServerObj.XCONTEXT,
		ObjectType:ObjectType
	},function(Data){
		var cbox = $HUI.combobox("#TemplTabName", {
				valueField: 'id',
				textField: 'text', 
				editable:false,
				data: Data,
				onSelect:function(rec){
					InitTeplGroup(rec['id'],"");
				},
				onLoadSuccess:function(){
					if (defTabName==""){
						if (Data.length>0){
							$(this).combobox('select',Data[0]['id']);
						}
					}else{
						for (var i=0;i<Data.length;i++){
							if (Data[i]['text']==defTabName){
								$(this).combobox('select',Data[i]['id']);
							}
						}
					}
				}
		 });
	});
}
//模板子表
function InitTeplGroup(TabNameIndex,defGroupDesc){
	$.cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"GetGroupDescListBroker",
		JSFunName:"GetGroupToHUIJson", ListName:"", UserID:session['LOGON.USERID'], Type:ServerObj.Type,
		TabNameIndex:TabNameIndex,
		CTLOCID:session['LOGON.CTLOCID'], XCONTEXT:ServerObj.XCONTEXT,
		ObjectType:$("#TemplCategory").combobox('getValue')
	},function(Data){
		var cbox = $HUI.combobox("#TemplGroup", {
				valueField: 'id',
				textField: 'text', 
				data: Data,
				onLoadSuccess:function(){
					if (defGroupDesc!=""){
						for (var i=0;i<Data.length;i++){
							if (Data[i]['text']==defGroupDesc){
								$(this).combobox('select',Data[i]['id']);
							}
						}
					}else{
						$(this).combobox('select',"");
					}
				}
		 });
	});
}
function BSaveGroupClickHandle(){
	var AddTabName=$.trim($("#TemplTabNameDesc").val());
	if (AddTabName==""){
		$.messager.alert("提示","模板组描述不能为空!","info",function(){
			$("#TemplTabNameDesc").focus();
		})
		return false;
	}
	if (PageLogicObj.pattern.test(AddTabName)){
		$.messager.alert("提示","模板组描述【"+AddTabName+"】含有非法字符!","info",function(){
			$("#TemplTabNameDesc").focus();
		});
		return false;
	}
	var data=$("#TemplTabName").combobox('getData');
	for (var i=0;i<data.length;i++){
		if (data[i]["text"]==AddTabName){
			$.messager.alert("提示",AddTabName+" 已存在!","info",function(){
				$("#TemplTabNameDesc").focus();
			});
			return false;
		}
	}
	var ObjectType=$("#TemplCategory").combobox('getValue');
	$.cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"AddTabName",
		UserID:session['LOGON.USERID'], Type:ServerObj.Type, TabName:AddTabName, CTLOCID:session['LOGON.CTLOCID'],
		XCONTEXT:ServerObj.XCONTEXT,
		ObjectType:ObjectType,
		dataType:"text"
	},function(ret){
		if (ret==0){
			$.messager.alert("提示","增加模板组成功","info",function(){
				InitTemplTabName(ObjectType,AddTabName);
				$("#AddTabName-tr").hide();
				$("#TemplTabNameDesc").val('');
			})
		}else{
			$.messager.alert("提示","增加模板组失败!");
			return false;
		}
	});
}
function BSaveTabNameClickHandle(){
	var AddGroupDesc=$.trim($("#TemplGroupDesc").val());
	if (AddGroupDesc==""){
		$.messager.alert("提示","模板子表描述不能为空!","info",function(){
			$("#TemplGroupDesc").focus();
		})
		return false;
	}
	if (PageLogicObj.pattern.test(AddGroupDesc)){
		$.messager.alert("提示","模板子表描述【"+AddGroupDesc+"】含有非法字符!","info",function(){
			$("#TemplGroupDesc").focus();
		});
		return false;
	}
	var TabDesc=$("#TemplTabName").combobox('getValue');
	if (TabDesc==""){
		$.messager.alert("提示","请先选择要加入的模板组");
		return false;
	}
	
	var data=$("#TemplGroup").combobox('getData');
	for (var i=0;i<data.length;i++){
		if (data[i]["text"]==AddGroupDesc){
			$.messager.alert("提示",AddGroupDesc+" 已存在!","info",function(){
				$("#TemplGroupDesc").focus();
			});
			return false;
		}
	}
	
	var ObjectType=$("#TemplCategory").combobox('getValue');
	$.cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"AddGroupDesc",
		UserID:session['LOGON.USERID'], Type:ServerObj.Type, TabNameIndex:TabDesc, GroupDesc:AddGroupDesc,
		CTLOCID:session['LOGON.CTLOCID'],
		XCONTEXT:ServerObj.XCONTEXT,
		ObjectType:ObjectType,
		dataType:"text"
	},function(ret){
		if (ret==0){
			$.messager.alert("提示","增加模板子表成功","info",function(){
				InitTeplGroup(TabDesc,AddGroupDesc);
				$("#AddGroup-tr").hide();
				$("#TemplGroupDesc").val('');
			})
		}else{
			$.messager.alert("提示","增加模板子表失败!");
			return false;
		}
	});
}
function BSaveClickHandle(){
	var ARCOSDesc=$("#ARCOS").lookup('getText');
	if (ARCOSDesc==""){
		PageLogicObj.m_selARCOSRowId="";
	}
	var TemplTabName=getCombValue("TemplTabName","id");
	var TemplGroup=getCombValue("TemplGroup","id");
	//var TemplTabName=$("#TemplTabName").combobox('getValue');
	//var TemplGroup=$("#TemplGroup").combobox('getValue');
	var ARCOSDesc=$("#ARCOSName").val();
	if ((TemplGroup=="")&&(PageLogicObj.m_selARCOSRowId=="")&&(ARCOSDesc=="")){
		$.messager.alert("提示","请选择医嘱套或模板子表!")
		return false;
	}
	if ((PageLogicObj.m_selARCOSRowId=="")&&($(".arcosnew").css("display")=="none")){
		//保存到模板
		SaveToTemplate();
		return false;
	}
	if (PageLogicObj.m_selARCOSRowId==""){
		//新增医嘱套保存
		var SubCategory=$("#SubCategory").combobox('getValue');
		if (SubCategory==""){
			$.messager.alert("提示","医嘱套子类不能为空!");
			return false;
		}
		var ARCOSName=$("#ARCOSName").val();
		if (ARCOSName==""){
			$.messager.alert("提示","医嘱套名称不能为空!","info",function(){
				$("#ARCOSName").focus();
			});
			return false;
		}
		var Code=$("#Code").val();
		var ARCOSAlias=$("#ARCOSAlias").val();
		if (ARCOSAlias==""){
			$.messager.alert("提示","医嘱套别名不能为空!","info",function(){
				$("#ARCOSAlias").focus();
			});
			return false;
		}
		var Conditiones=$("#Conditiones").combobox('getValue');
		if (Conditiones==""){
			$.messager.alert("提示","条件不能为空!");
			return false;
		}
		var DocMedUnit="",HospID="";
		//默认为个人
		if (Conditiones=="")   {Conditiones=1}
		if (Conditiones=="1") {
			var UserID=session['LOGON.USERID']; 
			var FavDepList="";
			var DocMedUnit="";
			//医嘱套的名字要加上Code
			if (ARCOSName.indexOf("-")<0){
				ARCOSName=session["LOGON.USERCODE"]+"-"+ARCOSName;
			}
		};
		//科室
		if (Conditiones=="2"){
			var UserID="";
			var FavDepList=session['LOGON.CTLOCID'];
			var DocMedUnit="";
		}
		if (Conditiones=="3") {
			var UserID="";
			var FavDepList="";
			var DocMedUnit="";
			HospID=session['LOGON.HOSPID'];
		}
		//if (Conditiones=="4") {var UserID=Guser;var FavDepList="";};
		var ARCOSCatID=$("#Category").combobox('getValue');
		var ret=$.cm({
			ClassName:"web.DHCUserFavItems",
			MethodName:"InsertUserARCOS",
			UserRowid:UserID, ARCOSCode:Code, ARCOSDesc:ARCOSName, ARCOSCatID:ARCOSCatID,
			ARCOSSubCatID:SubCategory,ARCOSEffectDate:"",ARCOSAlias:ARCOSAlias,UserID:session['LOGON.USERID'],
			FavDepList:FavDepList,DocMedUnit:DocMedUnit,HospID:HospID,
			dataType:"text"
		},false);
		if (ret=='-1') {
			$.messager.alert("提示","保存失败"+"  您可能填写了已经使用的代码");
			return;
		}else{
			var FavRowid=mPiece(ret,String.fromCharCode(1),0);
			var ARCOSRowid=mPiece(ret,String.fromCharCode(1),1);
			var ARCOSCode=mPiece(ret,String.fromCharCode(1),2);
		}
        if ((FavRowid=="")||(FavRowid==" ")){
	        $.messager.alert("提示","  您可能填写了已经使用的代码");
			return false;
	    }
	    //如果模板组、模板子表都不为空，则把新增的医嘱套保存至医嘱模板
		if ((TemplTabName!="")&&(TemplGroup!="")){
			var ObjectType=$("#TemplCategory").combobox('getValue');
			var IDStr=$.cm({
				ClassName:"web.DHCUserFavItems",
				MethodName:"GetUserwebsysPreferencesID",
				UserID:session['LOGON.USERID'], CTLoc:session['LOGON.CTLOCID'], XCONTEXT:ServerObj.XCONTEXT, ObjectType:ObjectType,
				dataType:"text"
			},false)
			if (ServerObj.Type=="西药"){
			    var ID=IDStr.split(",")[1];
			}else{
				var ID=IDStr.split(",")[2];
			}
			if (ID==""){
			    $.messager.alert("提示","没有找到相关模板的位置,保存到模板失败!");
			    return false
			}
			var ret=$.cm({
				ClassName:"web.DHCUserFavItems",
				MethodName:"SaveToTemplate",
				ID:ID, TabNameIndex:TemplTabName, groupnameIndex:TemplGroup, ARCOSRowid:ARCOSRowid, Type:"ARCOS",
				dataType:"text"
			},false);
			if(ret!=0){
				$.messager.alert("提示","保存到模板失败!");
			    return false
			}
		}
		var ObjectType=$("#TemplCategory").combobox('getValue');
		var value=ARCOSRowid+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+ObjectType;
	    if(ARCOSRowid==""){
		    /*window.returnValue=value
			window.close();*/
			websys_showModal("hide");
			if (websys_showModal('options').CallBackFunc) {
				websys_showModal('options').CallBackFunc(value);
			}			
			websys_showModal("close");
		    return false
		}
		//保存医嘱到医嘱套
		SaveArcosItem(value);
	}else{
		//如果模板组、模板子表都不为空，则把选择的医嘱套保存至医嘱模板
		if ((TemplTabName!="")&&(TemplGroup!="")){
			var ObjectType=$("#TemplCategory").combobox('getValue');
			var IDStr=$.cm({
				ClassName:"web.DHCUserFavItems",
				MethodName:"GetUserwebsysPreferencesID",
				UserID:session['LOGON.USERID'], CTLoc:session['LOGON.CTLOCID'], XCONTEXT:ServerObj.XCONTEXT, ObjectType:ObjectType,
				dataType:"text"
			},false)
			if (ServerObj.Type=="西药"){
			    var ID=IDStr.split(",")[1];
			}else{
				var ID=IDStr.split(",")[2];
			}
			if (ID==""){
			    $.messager.alert("提示","没有找到相关模板的位置,保存到模板失败!");
			    return false
			}
			var ret=$.cm({
				ClassName:"web.DHCUserFavItems",
				MethodName:"SaveToTemplate",
				ID:ID, TabNameIndex:TemplTabName, groupnameIndex:TemplGroup, ARCOSRowid:PageLogicObj.m_selARCOSRowId, Type:"ARCOS",
				dataType:"text"
			},false);
			if(ret!=0){
				$.messager.alert("提示","保存到模板失败!");
			    return false
			}
		}
		//保存医嘱到医嘱套
		var ObjectType=$("#TemplCategory").combobox('getValue');
		var value=PageLogicObj.m_selARCOSRowId+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+ObjectType;
		SaveArcosItem(value);
	}
}
function ARCOSNameChange(){
	var ARCOSName=$("#ARCOSName").val();
	var alias=$.cm({
		ClassName:"ext.util.String",
		MethodName:"ToChineseSpell",
		Chinese:ARCOSName,
		dataType:"text"
	},false)
	$("#ARCOSAlias").val(alias);
}
function mPiece(str,deli,index){
	return str.split(deli)[index];
}
function SaveToTemplate(){
	var TemplTabName=getCombValue("TemplTabName","id");
	if (TemplTabName==""){
		$.messager.alert("提示","模板组不能为空!");
		return false;
	}
	var TemplGroup=getCombValue("TemplGroup","id");
	if (TemplGroup==""){
		$.messager.alert("提示","模板子表不能为空!");
		return false;
	}
	var ObjectType=$("#TemplCategory").combobox('getValue');
	var IDStr=$.cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"GetUserwebsysPreferencesID",
		UserID:session['LOGON.USERID'], CTLoc:session['LOGON.CTLOCID'], XCONTEXT:ServerObj.XCONTEXT, ObjectType:ObjectType,
		dataType:"text"
	},false)
	if (ServerObj.Type=="西药"){
	    var ID=IDStr.split(",")[1];
	}else{
		var ID=IDStr.split(",")[2];
	}
	if (ID==""){
	    $.messager.alert("提示","没有找到相关模板的位置,保存到模板失败!");
	    return false
	}
	var AddTOArcosARCIMDatasOneArcimArrStr=PageLogicObj.m_AddTOArcosARCIMDatas.split(String.fromCharCode(3));
	var len=AddTOArcosARCIMDatasOneArcimArrStr.length;
	if (len<1) return;
	for(var i=0;i<len;i++){ 
	    //门诊的已经审核但未收费不会在录入的医嘱套中
	    var AddTOArcosARCIMDatasOneArcimArr=AddTOArcosARCIMDatasOneArcimArrStr[i].split("^");
		var OrderARCIMRowid=AddTOArcosARCIMDatasOneArcimArr[0];
		var OrderBodyPartLabel=AddTOArcosARCIMDatasOneArcimArr[18];
		if (OrderBodyPartLabel!="") OrderARCIMRowid=OrderARCIMRowid+"*S*"+OrderBodyPartLabel;
		var ret=$.cm({
			ClassName:"web.DHCUserFavItems",
			MethodName:"SaveToTemplate",
			ID:ID, TabNameIndex:TemplTabName, groupnameIndex:TemplGroup, ARCOSRowid:OrderARCIMRowid, Type:"ARCIM",
			dataType:"text"
		},false)
	    if (ret!=0){
	        $.messager.alert("提示",ret.split("^")[1]);
	        return false;
	    }
	}
	if(ret==0){
	     $.messager.alert("提示","保存到模板成功!","info",function(){
		     var value=""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+ObjectType;
		      /*window.returnValue=value;
		      window.close();*/
		      websys_showModal("hide");
			  if (websys_showModal('options').CallBackFunc) {
				 websys_showModal('options').CallBackFunc(value);
			  }			
			  websys_showModal("close");
		      return true;
		 })
	}
}
function SaveArcosItem(value){
	var OrderSeqNoArr = new Array();
	var ARCOSRowid=value.split("^")[0];
	var ArcosMaxLinkSeqNo=tkMakeServerCall("web.DHCARCOrdSets", "GetArcosMaxLinkSeqNo", ARCOSRowid) //获取不重复的LinkNo
	if (ArcosMaxLinkSeqNo<0) {
		ArcosMaxLinkSeqNo=1
	}else {
		ArcosMaxLinkSeqNo++
	}
	var AddTOArcosARCIMDatasOneArcimArrStr=PageLogicObj.m_AddTOArcosARCIMDatas.split(String.fromCharCode(3));
	var len=AddTOArcosARCIMDatasOneArcimArrStr.length;
    for(var i=0;i<len;i++){ 
	    //门诊的已经审核但未收费不会在录入的医嘱套中
	    var AddTOArcosARCIMDatasOneArcimArr=AddTOArcosARCIMDatasOneArcimArrStr[i].split("^")
		var OrderARCIMRowid=AddTOArcosARCIMDatasOneArcimArr[0];
		var OrderPackQty=AddTOArcosARCIMDatasOneArcimArr[1];
		var OrderDoseQty=AddTOArcosARCIMDatasOneArcimArr[2];
		var OrderDoseUOM=AddTOArcosARCIMDatasOneArcimArr[3];
		var OrderFreqRowID=AddTOArcosARCIMDatasOneArcimArr[4];
		var OrderDurRowid=AddTOArcosARCIMDatasOneArcimArr[5];
		var OrderInstrRowID=AddTOArcosARCIMDatasOneArcimArr[6];
		var OrderMasterSeqNo=AddTOArcosARCIMDatasOneArcimArr[7];
		if (OrderMasterSeqNo!="") {
			var ItemOrderSeqNoArr=OrderMasterSeqNo.split(".");
			if (!OrderSeqNoArr[ItemOrderSeqNoArr[0]]) {
				OrderSeqNoArr[ItemOrderSeqNoArr[0]]=ArcosMaxLinkSeqNo;
				ArcosMaxLinkSeqNo++;
			}
			if (ItemOrderSeqNoArr.length>1) {
				OrderMasterSeqNo=OrderSeqNoArr[ItemOrderSeqNoArr[0]]+"."+ItemOrderSeqNoArr[1];
			}else{
				OrderMasterSeqNo=OrderSeqNoArr[ItemOrderSeqNoArr[0]];
			}
		}
		var OrderDepProcNote=AddTOArcosARCIMDatasOneArcimArr[8];
		var OrderPriorRowid=AddTOArcosARCIMDatasOneArcimArr[9];
		var SampleId=AddTOArcosARCIMDatasOneArcimArr[10];
		var OrderPriorRemarks=AddTOArcosARCIMDatasOneArcimArr[12];
		var OrderStageCode=AddTOArcosARCIMDatasOneArcimArr[13];
		var OrderSpeedFlowRate=AddTOArcosARCIMDatasOneArcimArr[14];
        var OrderFlowRateUnitRowId=AddTOArcosARCIMDatasOneArcimArr[15];
        var OrderPackUOM=AddTOArcosARCIMDatasOneArcimArr[16];
        var OrderRecDepRowid=AddTOArcosARCIMDatasOneArcimArr[17];
		var OrderBodyPartLabel=AddTOArcosARCIMDatasOneArcimArr[18];
		var OrderFreqTimeDoseStr=AddTOArcosARCIMDatasOneArcimArr[19];
		if (OrderFreqTimeDoseStr!="") {
			OrderFreqTimeDoseStr=OrderFreqTimeDoseStr.replace(/_/g,"||");
			OrderFreqTimeDoseStr=OrderFreqTimeDoseStr.replace(new RegExp(String.fromCharCode(2),"g"),"!");
			OrderDoseQty="";
		}
		var OrderFreqWeekStr=AddTOArcosARCIMDatasOneArcimArr[20];
		var OrderSkinTest=AddTOArcosARCIMDatasOneArcimArr[21];
		var OrderActionRowid=AddTOArcosARCIMDatasOneArcimArr[22];
        var MustEnter="N";
        var ExpStr=OrderStageCode+"^"+MustEnter+"^"+OrderPackUOM;
        ExpStr=ExpStr+"^"+OrderSpeedFlowRate+"^"+OrderFlowRateUnitRowId+"^"+OrderBodyPartLabel;
        ExpStr=ExpStr+"^"+OrderSkinTest+"^"+OrderActionRowid;
        ExpStr=ExpStr+"^^^"+OrderFreqTimeDoseStr+"^"+OrderFreqWeekStr;
        var ret=$.cm({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"InsertItem",
			ARCOSRowid:ARCOSRowid, ARCIMRowid:OrderARCIMRowid, ItemQty:OrderPackQty, ItemDoseQty:OrderDoseQty,
			ItemDoseUOMID:OrderDoseUOM, ItemFrequenceID:OrderFreqRowID, ItemDurationID:OrderDurRowid, ItemInstructionID:OrderInstrRowID,
			ItmLinkDoctor:OrderMasterSeqNo, remark:OrderDepProcNote, DHCDocOrderTypeID:OrderPriorRowid,
			SampleId:SampleId, ARCOSItemNO:"", OrderPriorRemarksDR:OrderPriorRemarks, DHCDocOrderRecLoc:OrderRecDepRowid, ExpStr:ExpStr,
			dataType:"text"
		},false)
	}
	$.messager.alert("提示","保存到医嘱套成功!","info",function(){
		/*window.returnValue=value
		window.close();*/
		websys_showModal("hide");
	  	if (websys_showModal('options').CallBackFunc) {
		  websys_showModal('options').CallBackFunc(value);
	    }			
	    websys_showModal("close");
		return;
	});
}
function getCombValue(id,valueField){
	var Find=0;
	var selId=$('#'+id).combobox('getValue');
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 var CombValue=Data[i][valueField];
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}