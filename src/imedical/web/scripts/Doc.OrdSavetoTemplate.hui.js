var PageLogicObj={
	m_selARCOSRowId:"",
	m_AddTOArcosARCIMDatas:"",
	pattern:new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~��@#������&*��������|{}��������������'��������]") 
}
$(function(){
	ExtendHISUICombo();
	//�¼���ʼ��
	InitEvent();
	//ҳ��Ԫ�س�ʼ��
	PageHandle();
})
function InitEvent(){
	$("#BAddARCOS").click(BAddARCOSClickHandle);
	$("#BAddTabName").click(BAddTabNameClick);
	$("#BAddTemplGroup").click(BAddTemplGroupClick);
	//����ģ����� ����
	$("#BSaveGroup").click(BSaveGroupClickHandle);
	//����ģ���ӷ����� ����
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
			{field:'ARCOSName',title:'ҽ��������',width:350}
        ]], 
        pagination:true,
        panelWidth:400,
		panelHeight:310,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:false,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpARCOS',EditAuthFlag:1},
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
			 if (Data['rows'][i]['CombDesc'].indexOf($g("ҽ����"))>=0){
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
		CombName:"SubCategory",Inpute1:CategoryId,Inpute2:"XY",
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
			data: [{"id":1,"text":$g("����")},{"id":2,"text":$g("����")},{"id":3,"text":$g("ȫԺ")}]
	 });
}
function InitTempl(){
	InitTemplCategory();
	InitTemplTabName();
	InitTeplGroup();
}
function InitTemplCategory(){
	var dataArr=new Array();
	dataArr.push({"id":"User.SSUser","text":$g("����"),selected:true});
	if(ServerObj.MenuAuthOrderOrgFav==1){
		dataArr.push({"id":"User.CTLoc","text":$g("����")});
	}
	if(ServerObj.HospMenuAuthOrderOrgFav==1){
		dataArr.push({"id":"User.CTHospital","text":$g("ȫԺ")});
	}
	$("#TemplCategory").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:false,
		data: dataArr,
		onSelect:function(){
			$('#TemplTabName').combobox('reload');
		},
		onLoadSuccess:function(){
			$('#TemplTabName').combobox('reload');
		}
	 });
}
//ģ�����
function InitTemplTabName(){
	$('#TemplTabName').combobox({
		url:'websys.Broker.cls',
		valueField: 'id',
		textField: 'text', 
		editable:false,
		onSelect:function(rec){
			if(rec) $("#TemplGroup").combobox('loadData',rec.children);
			else $("#TemplGroup").combobox('loadData',[]);
		},
		onBeforeLoad:function(param){
			var ObjectType=$("#TemplCategory").combobox('getValue');
			$.extend(param,{
				ClassName:"DHCDoc.Order.Fav",
				MethodName:"GetFavData", 
				Type:ObjectType,
				CONTEXT:ServerObj.XCONTEXT, 
				LocID:session['LOGON.CTLOCID'],
				UserID:session['LOGON.USERID'],
				OnlyCatNode:1
			});
			$(this).combobox('select','');
			return true;
		}
	});
}
//ģ���ӷ�����
function InitTeplGroup(){
	$("#TemplGroup").combobox({
		valueField: 'id',
		textField: 'text', 
		data: [],
		onLoadSuccess:function(data){
			if(data.length){
				$(this).combobox('select',data[0].id);
			}else{
				$(this).combobox('select','');
			}
		}
	});
}
function BSaveGroupClickHandle(){
	var AddTabName=$.trim($("#TemplTabNameDesc").val());
	if (AddTabName==""){
		$.messager.alert("��ʾ","ģ�������������Ϊ��!","info",function(){
			$("#TemplTabNameDesc").focus();
		})
		return false;
	}
	if (PageLogicObj.pattern.test(AddTabName)){
		$.messager.alert("��ʾ",$g("ģ�����������")+AddTabName+$g("�����зǷ��ַ�!"),"info",function(){
			$("#TemplTabNameDesc").focus();
		});
		return false;
	}
	var data=$("#TemplTabName").combobox('getData');
	for (var i=0;i<data.length;i++){
		if (data[i]["text"]==AddTabName){
			$.messager.alert("��ʾ",AddTabName+$g(" �Ѵ���!"),"info",function(){
				$("#TemplTabNameDesc").focus();
			});
			return false;
		}
	}
	var ObjectType=$("#TemplCategory").combobox('getValue');
	var ret=$.cm({
		ClassName:'DHCDoc.Order.Fav',
		MethodName:'SaveCat',
		Type:ObjectType,
		CONTEXT:ServerObj.XCONTEXT, 
		Name:AddTabName,
		LocID:session['LOGON.CTLOCID'],
		UserID:session['LOGON.USERID'],
		ID:'',
		dataType:'text'
	},false);
	if(ret.split('^')[0]=='0'){
		$('#TemplTabName').combobox('reload');
		$.messager.popover({msg:'����ɹ�',type:'success'});
		$("#AddTabName-tr").hide();
		$("#TemplTabNameDesc").val('');
		setTimeout(function(){$('#TemplTabName').combobox('setValueByText',AddTabName);},200);
	}else{
		$.messager.alert('��ʾ',ret,'warning',function(){$("#TemplTabNameDesc").select()});
	}
}
function BSaveTabNameClickHandle(){
	var AddGroupDesc=$.trim($("#TemplGroupDesc").val());
	if (AddGroupDesc==""){
		$.messager.alert("��ʾ","ģ���ӷ�������������Ϊ��!","info",function(){
			$("#TemplGroupDesc").focus();
		})
		return false;
	}
	if (PageLogicObj.pattern.test(AddGroupDesc)){
		$.messager.alert("��ʾ","ģ���ӷ�����������"+AddGroupDesc+"�����зǷ��ַ�!","info",function(){
			$("#TemplGroupDesc").focus();
		});
		return false;
	}
	var CatID=$("#TemplTabName").combobox('getValue');
	if (CatID==""){
		$.messager.alert("��ʾ","����ѡ��Ҫ�����ģ�����");
		return false;
	}
	var ret=$.cm({
		ClassName:'DHCDoc.Order.Fav',
		MethodName:'SaveSubCat',
		ID:'',
		CatID:CatID,
		Name:AddGroupDesc, 
		UserID:session['LOGON.USERID'], 
		dataType:'text'
	},false);
	if(ret.split('^')[0]=='0'){
		var oldValue=$('#TemplTabName').combobox('getValue');
		$('#TemplTabName').combobox('reload');
		setTimeout(function(){$('#TemplTabName').combobox('select',oldValue);},200);
		setTimeout(function(){$('#TemplGroup').combobox('setValueByText',AddGroupDesc);},300);
		$("#AddGroup-tr").hide();
		$("#TemplGroupDesc").val('');
		$.messager.popover({msg:'����ɹ�',type:'success'});
		
	}else{
		$.messager.alert('��ʾ',ret,'warning',function(){$("#TemplGroupDesc").find('input').select()});
	}
}
function BSaveClickHandle(){
	var ARCOSDesc=$("#ARCOS").lookup('getText');
	if (ARCOSDesc=="") PageLogicObj.m_selARCOSRowId="";
	var SubCatID=$('#TemplGroup').combobox('getValue');
	var ARCOSName=$('#ARCOSName').val();
	if((SubCatID=='')&&(PageLogicObj.m_selARCOSRowId=='')&&(ARCOSName=='')){
		$.messager.popover({msg:'��ѡ��ҽ���׻���ģ������',type:'alert'});
		return;
	}
	if(PageLogicObj.m_selARCOSRowId||(ARCOSName!='')){
		if(!SaveArcosItem()){
			return;
		}
	}
	if(SubCatID!=''){
		if(!SaveToTemplate()){
			return
		}
	}
	$.messager.alert("��ʾ","����ɹ�!","info",function(){
		var ObjectType=$("#TemplCategory").combobox('getValue');
		var value=""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+ObjectType;
		websys_showModal("hide");
		if (websys_showModal('options').CallBackFunc) {
			websys_showModal('options').CallBackFunc(value);
		}			
		websys_showModal("close");
		return true;
	});
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
	var SubCatID=$('#TemplGroup').combobox('getValue');
	if(SubCatID==''){
		return false;
	}
	var itemArr=new Array();
	if(!PageLogicObj.m_selARCOSRowId){
		var arcimArr=PageLogicObj.m_AddTOArcosARCIMDatas.split(String.fromCharCode(3));
		for(var i=0;i<arcimArr.length;i++){ 
			var AddTOArcosARCIMDatasOneArcimArr=arcimArr[i].split("^");
			var OrderARCIMRowid=AddTOArcosARCIMDatasOneArcimArr[0];
			var OrderBodyPartLabel=AddTOArcosARCIMDatasOneArcimArr[18];
			itemArr.push({'itemid':OrderARCIMRowid,note:'',partInfo:OrderBodyPartLabel});
		}
	}else{
		itemArr.push({'itemid':PageLogicObj.m_selARCOSRowId,note:'',partInfo:''});
	}
	if(itemArr.length){
		var ret=$.cm({ 
			ClassName:"DHCDoc.Order.Fav",
			MethodName:"InsertMultItem", 
			FavItemStr:JSON.stringify(itemArr),
			SubCatID:SubCatID,
			UserID:session['LOGON.USERID'],
			dataType:'text'
		},false);
		if(ret=='0'){
			return true
		}else{
			$.messager.alert('��ʾ','����ģ��ʧ��:'+ret);
			return false;
		}
	}
	return true;
}
function SaveArcosItem(){
	if (PageLogicObj.m_selARCOSRowId==""){
		//����ҽ���ױ���
		var SubCategory=$("#SubCategory").combobox('getValue');
		if (SubCategory==""){
			$.messager.alert("��ʾ","ҽ�������಻��Ϊ��!");
			return false;
		}
		var ARCOSName=$("#ARCOSName").val();
		if (ARCOSName==""){
			$.messager.alert("��ʾ","ҽ�������Ʋ���Ϊ��!","info",function(){
				$("#ARCOSName").focus();
			});
			return false;
		}
		var Code=$("#Code").val();
		var ARCOSAlias=$("#ARCOSAlias").val();
		if (ARCOSAlias==""){
			$.messager.alert("��ʾ","ҽ���ױ�������Ϊ��!","info",function(){
				$("#ARCOSAlias").focus();
			});
			return false;
		}
		var Conditiones=$("#Conditiones").combobox('getValue');
		if (Conditiones==""){
			$.messager.alert("��ʾ","��������Ϊ��!");
			return false;
		}
		var DocMedUnit="",UserID=session['LOGON.USERID'],FavDepList=session['LOGON.CTLOCID'],HospID=session['LOGON.HOSPID'];
		var ToType="User"
		switch(Conditiones){
			case "2":
				if (!ServerObj.LocARCOSAuthority){
					$.messager.alert("��ʾ","û��Ȩ��ά������ҽ������");
					return false;
				}
				ToType="Loc";
				break;
			case "3":
				if (!ServerObj.HospARCOSAuthority){
					$.messager.alert("��ʾ","û��Ȩ��ά��ȫԺҽ����");
					return false;
				}
				ToType="Hosp";
				break
			default:
				//����ҽ���׵�����Ҫ����Code
				if (ARCOSName.indexOf("-")<0){
					ARCOSName=session["LOGON.USERCODE"]+"-"+ARCOSName;
				}
				break;
		}
		var ARCOSCatID=$("#Category").combobox('getValue');
		var ret=$.cm({
			ClassName:"web.DHCUserFavItems",
			MethodName:"InsertUserARCOS",
			UserRowid:UserID, ARCOSCode:Code, ARCOSDesc:ARCOSName, ARCOSCatID:ARCOSCatID,
			ARCOSSubCatID:SubCategory,ARCOSEffectDate:"",ARCOSAlias:ARCOSAlias,UserID:session['LOGON.USERID'],
			FavDepList:FavDepList,DocMedUnit:DocMedUnit,HospID:HospID,Type:ToType,
			dataType:"text"
		},false);
		if (ret=='-1') {
			$.messager.alert("��ʾ","����ҽ����ʧ��"+"  ��������д���Ѿ�ʹ�õĴ���");
			return false;
		}else{
			var FavRowid=mPiece(ret,String.fromCharCode(1),0);
			var ARCOSRowid=mPiece(ret,String.fromCharCode(1),1);
			var ARCOSCode=mPiece(ret,String.fromCharCode(1),2);
			PageLogicObj.m_selARCOSRowId=ARCOSRowid;
		}
	}
	var ARCOSType=$.cm({
		ClassName:"web.DHCUserFavItems",
		MethodName:"GetARCOSType",
		ARCOSRowid:PageLogicObj.m_selARCOSRowId,
		dataType:"text"
	},false)
	if ((ARCOSType=="Loc")&&(!ServerObj.LocARCOSAuthority)){
		$.messager.alert("��ʾ","û��Ȩ��ά������ҽ������");
		return false;
	}
	if ((ARCOSType=="Hosp")&&(!ServerObj.HospARCOSAuthority)){
		$.messager.alert("��ʾ","û��Ȩ�ޱ���ȫԺҽ����");
		return false;
	}
	var OrderSeqNoArr = new Array();
	var ARCOSRowid=PageLogicObj.m_selARCOSRowId;
	var ArcosMaxLinkSeqNo=tkMakeServerCall("web.DHCARCOrdSets", "GetArcosMaxLinkSeqNo", ARCOSRowid) //��ȡ���ظ���LinkNo
	if (ArcosMaxLinkSeqNo<0) {
		ArcosMaxLinkSeqNo=1
	}else {
		ArcosMaxLinkSeqNo++
	}
	var AddTOArcosARCIMDatasOneArcimArrStr=PageLogicObj.m_AddTOArcosARCIMDatas.split(String.fromCharCode(3));
	var len=AddTOArcosARCIMDatasOneArcimArrStr.length;
    for(var i=0;i<len;i++){
	    //������Ѿ���˵�δ�շѲ�����¼���ҽ������
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
		var NotifyClinician=AddTOArcosARCIMDatasOneArcimArr[23];
        var MustEnter="N";
        var ExpStr=OrderStageCode+"^"+MustEnter+"^"+OrderPackUOM;
        ExpStr=ExpStr+"^"+OrderSpeedFlowRate+"^"+OrderFlowRateUnitRowId+"^"+OrderBodyPartLabel;
        ExpStr=ExpStr+"^"+OrderSkinTest+"^"+OrderActionRowid;
        ExpStr=ExpStr+"^"+NotifyClinician+"^^"+OrderFreqTimeDoseStr+"^"+OrderFreqWeekStr;
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
	return true;
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
function ExtendHISUICombo()
{
	$.extend($.fn.combobox.methods, {    
	    setValueByText: function(jq, text){    
	        return jq.each(function(){  
	        	var opts=$(this).combobox('options');
	        	var data=$(this).combobox('getData');
	        	for(var i=0;i<data.length;i++){
		        	if(data[i][opts.textField]==text){  
	            		$(this).combobox('select', data[i][opts.valueField]);
	            		break;
		        	}
	        	} 
	        });    
	    }    
	});
}