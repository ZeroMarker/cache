var UDHCFavOrderSetsEditDataGrid; //ҽ����DataGride
var UDHCARCOrderSetItemEditDataGrid; //ҽ��������DataGride
var ARCOSRowid=""; //ҽ����ID
var SelectRow1="-1"; //ѡ��ҽ������ -1��ʾδѡ��
var DfaultCatID="" //ҽ������Ĭ��ֵ
var ForQueryLoc="" //ѡ�еĿ���ģ�帳ֵ����ID ���Ϊ����ʱ���ж�
var FavEditLay="Y" //����ҽ����ģ��չ��״̬ Yչ��Nû��չ��
var ItemEditLay="Y" //����ҽ����ϸ��Ϣչ��״̬ Yչ��Nû��չ��
//var DelHospARCOSAuthority=tkMakeServerCall("web.DHCDocConfig","GetConfigNode1","DelHospARCOSAuthority",session['LOGON.GROUPID']);
var ARCOSToolBar,ARCOSItemToolBar;
var ModifyHospArcosFlag=1;
var CNFreqArr="",CNDurationArr="",CNInstrArr="",CNPrescTypeArr=""
var DescchangeTime;
$(function(){
	//��ʼ������ҽ����ģ��datagrid
	LoadDataForFav();	
});

function BodyLoadHandler(){
	Resizetab();
	//��ʼ��Comb�������
	CombListCreat()
	//��ʼ�����尴ť�¼�
	ButtonFunction()
	//ҽ��������۵����޸�ҽ������ϸ����---
	$('#UDHCFavOrderSetsEditLay').panel({onCollapse:UDHCFavStyle,onExpand:UDHCFavStyle})
}
//��ť�¼�����
function ButtonFunction(){
	//ҽ����
	$('#Search1').click(LoadUDHCFavOrderSetsEditDataGrid); //��ѯ
	$('#ClearFind').click(function(){
		ClearARCOSInfo(true);
		
    }); 
    $("#Desc").change(function (e){
		clearTimeout(DescchangeTime);
        DescchangeTime = setTimeout(function() { AutoSetAlias(e);}, 250);
	});
	$("#Desc").keydown(function(e){
		var keycode = websys_getKey(e);
		if ((keycode==9||keycode==13)){
			AutoSetAlias(e);
		}
	});
	$('#CNSaveBtn').click(function(){
        CNSaveClickHandler();
    });
    $('#main').layout('panel', 'east').panel({
        onBeforeExpand: function() {
	        var rowData=UDHCFavOrderSetsEditDataGrid.datagrid('getSelected');
			if(!rowData){
				$.messager.alert('��ʾ','δѡ���ҩҽ����!');
				return false;
			}
			if(rowData) ARCOSOrdSubCatDR=rowData.ARCOSOrdSubCatDR;
			if(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")<0){
				$.messager.alert('��ʾ','��ѡ���ҩҽ����!');
				return false;
			}
        }
    });
    $("#BSaveARCLocAuthorize").click(BSaveARCLocAuthorize);
}
function Resizetab(){
    var width=$(window).width()-48;
    $('#main').layout('panel', 'center').panel('resize',{width:width})
    $("#UDHCFavOrderSetsEdit").datagrid("resize");
}

function AutoSetAlias(e) {
	var Desc=$("#Desc").val();
	if (Desc==""){return true;}
	if (Desc.indexOf("-")>=0){
		Desc=Desc.split("-").slice(1).join("-");
	}
	var Spell=tkMakeServerCall("ext.util.String","ToChineseSpell",Desc);
	var Alias=$("#Alias").val();
	if ((Alias!="")&&(Alias!=Spell)){
		if (dhcsys_confirm("�Ƿ񽫱����滻Ϊ"+Spell+"?")){
			$("#Alias").val(Spell);
		}
	}else{
		$("#Alias").val(Spell);
	}
}
//ɾ��ҽ������ϸ
function LDeleteClickHandler()
{
	var rowdata=$('#UDHCARCOrderSetItemEdit').datagrid('getSelections')
	if (rowdata){
		if (rowdata.length==0){
			$.messager.alert('��ʾ','��ѡ����Ҫɾ����ҽ��!');
			return false;
		}
		for (var i=0;i<rowdata.length;i++){
			var ARCOSItemRowid=rowdata[i].ARCOSItemRowid;
			var ARCIMDesc=rowdata[i].ARCIMDesc;
			var ARCIMRowid=rowdata[i].ARCIMRowid;
			if (ARCOSItemRowid!=""){
				var ReturnValue=$.cm({
					ClassName:"web.DHCARCOrdSets",
					MethodName:"DeleteItem",
					ARCOSItemRowid:ARCOSItemRowid, 
					ARCIMRowid:ARCIMRowid,
					dataType:"text"
				},false);
				if (ReturnValue=="-1"){
					$.messager.alert('��ʾ',ARCIMDesc+'ɾ��ʧ��');
					return false;
				}
			}
		}
		LoadUDHCARCOrderSetItemEditDataGrid()
	}
}
// ����ҽ������Ŀ
function LAddClickHandler(){
	OpenArcosEditWindow(ARCOSRowid,"")
}

//�޸�ҽ������ϸ-����
function LUpdateClickHandler(){
	var rowdata=$('#UDHCARCOrderSetItemEdit').datagrid('getSelections')
	if (rowdata){
		if (rowdata.length==0){
			$.messager.alert('��ʾ','��ѡ����Ҫ�޸ĵ���Ŀ!');
			return false;
		}
		if (rowdata.length>1){
			$.messager.alert('��ʾ','��ѡ��һ����Ч��ҽ����Ϣ���и���');
			return false;
		}
		var ARCOSItemRowid=rowdata[0].ARCOSItemRowid;
		var ARCIMRowid=rowdata[0].ARCIMRowid;
		OpenArcosEditWindow(ARCOSRowid,ARCOSItemRowid,ARCIMRowid)
	}
}
//��ҽ������ϸ�༭����
function OpenArcosEditWindow(EditARCOSRowid,ARCOSItemRowid,ARCIMRowid){
if (EditARCOSRowid==""){
	   $.messager.alert('��ʾ','��ѡ����Ӧ��ҽ����');
	   return false;
   }
   var src="udhcfavitem.edit.newedit.csp?&ARCOSItemRowid="+ARCOSItemRowid+"&ARCOSRowid="+EditARCOSRowid+"&ARCIMRowid="+ARCIMRowid;   
   if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
   var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
   createModalDialog("ARCOSEdit","ҽ������ϸά��",490 , 560,"icon-w-edit","",$code,"");
}
//�����µ�ҽ����
function AddClickHandler(SaveType)
{
	var Contions=getValue("Conditiones"); //$('#Conditiones').combobox('getValue')
	if ((Contions=="")&&(SaveType!="SaveToUser")){
		$.messager.alert('��ʾ','����Ϊ��ѡ��,��ѡ��!');
		return false;
	}
	var UserID=session['LOGON.USERID']
	var UserCode=session["LOGON.USERCODE"];
	var GroupID=session['LOGON.GROUPID'];
	var	CTLOCID=session['LOGON.CTLOCID'];
	var HospID=""
	var ARCOSCode="" //$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSCatID=$('#Category').combobox('getValue');
	var ARCOSSubCatID=$('#SubCategory').combobox('getValue')
	var Data=$('#SubCategory').combobox("getData");
	if ($('#CelerType').checkbox("getValue")){
		var CelerType="Y";
	}else{
		var CelerType="N";
	}
	if((CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0)&&(CelerType=="Y")){
		$.messager.alert('��ʾ','��ҩҽ�����ݲ�֧�ֿ���¼�룡'); 
		return;
	}
	if ((CMFlag=="Y")&&(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")<0)) {
		$.messager.alert('��ʾ','��ѡ���ҩ��ص�ҽ��������!'); 
		return;
	}
	if ((CMFlag=="N")&&(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0)) {
		$.messager.alert('��ʾ','��ѡ����ҩ��ص�ҽ��������!'); 
		return;
	}
	var ARCOSSubCatID1=""
	for (var i=0;i<Data.length;i++) {
		if (Data[i] && Data[i].CombValue==ARCOSSubCatID) {
    	    ARCOSSubCatID1=Data[i] && Data[i].CombValue
		}
	}
	ARCOSSubCatID=ARCOSSubCatID1
	var ARCOSEffDateFrom=NowDate
	var FavDepList=CTLOCID;
	var DocMedUnit=""
	if (ARCOSDesc==""){
		$.messager.alert('��ʾ','ҽ�������Ʋ���Ϊ��,����д����!'); 
		return;
	}
	if (ARCOSAlias==""){
		$.messager.alert('��ʾ','ҽ���ױ�������Ϊ��,����д����!'); 
		return;
	}
	/*if (ARCOSCode=='') {
		$.messager.alert('��ʾ','ҽ���״��벻��Ϊ��,����д����!');
		return;
	}*/
	if (UserID==""){
		$.messager.alert('��ʾ','ȱ���û���Ϣ,��ˢ�½������µ�½���ٴγ���!'); 
		return;
	}
	if (ARCOSCatID==""){
		$.messager.alert('��ʾ','��ѡ����Ӧ��ҽ���״���!'); 
		return;
	}
	if (ARCOSSubCatID==""){
		$.messager.alert('��ʾ','��ѡ����Ӧ��ҽ��������!'); 
		return;
	}
	//ȡ��
	var DocMedUnit=tkMakeServerCall("web.DHCUserFavItems","GetMedUnit",UserID,CTLOCID);
	var FavDepList="";
	var InUser=UserID;
	if(SaveType=="SaveToUser"){
		Contions=1
	}
	//�����ж��������ֵ
	if (Contions=="1"){
		FavDepList="";DocMedUnit="";
		//ҽ���׵�����Ҫ����Code
		if (ARCOSDesc.indexOf("-")<0){
			ARCOSDesc=UserCode+"-"+ARCOSDesc;
		}
	}else if (Contions=="2"){
		InUser="";FavDepList=CTLOCID;DocMedUnit=""
	}else if(Contions=="3"){
		InUser="";FavDepList="";DocMedUnit="";
		HospID=session['LOGON.HOSPID']
	}else if(Contions=="4"){
		FavDepList="";
		if (DocMedUnit==''){
			$.messager.alert('��ʾ','��û�б����뵽��½������Ч������,���ܽ��и���������');
			return;
		}
	}
	var ret="";
	if (SaveType=="SaveToUser"){	
		//���Ϊ����ģ��
		if (ForQueryLoc==""){
			$.messager.alert('��ʾ','�ǿ���ģ�岻�ܱ���Ϊ����');
			return
		}
		if (ARCOSRowid==""){
			$.messager.alert('��ʾ','��ѡ����Ҫ����Ϊ����ģ��Ŀ���ģ��');
			return
		}
		FavDepList="";DocMedUnit="";
		var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
		ret=tkMakeServerCall("web.DHCUserFavItems","SaveAsUser",ARCOSRowid,InUser,ARCOSCode+"RS",ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit,HospID,CelerType,session['LOGON.HOSPID']);
	}else{
		//����ҽ����
		ret=tkMakeServerCall("web.DHCUserFavItems","InsertUserARCOS",InUser,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,UserID,FavDepList,DocMedUnit,HospID,CelerType,session['LOGON.HOSPID'])
	}
	if (ret=='-1') {
		$.messager.alert('��ʾ',"����ҽ����ʧ����������д���Ѿ�ʹ�õĴ���!");
		return;
	}else{
		if (SaveType=="SaveToUser") {
			var FavRowid=ret;
		}else {
			var FavRowid=ret.split(String.fromCharCode(1))[0];
			var ARCOSRowidGet=ret.split(String.fromCharCode(1))[1];
			var ARCOSCode=ret.split(String.fromCharCode(1))[2];
			$("#Code").val(ARCOSCode);
		}
		FavRowid=FavRowid.replace(/(^\s*)|(\s*$)/g,'')
		if (FavRowid==""){
	      $.messager.alert('��ʾ'," ��������д���Ѿ�ʹ�õĴ���");
		  return;
		}
  }
  $.messager.popover({msg: '����ɹ���',type:'success'});
  CloseWindow(ARCOSRowidGet,ARCOSSubCatID,SaveType=="SaveToUser"?"":"A");
  
  LoadUDHCFavOrderSetsEditDataGrid();	
}
//ҽ����ɾ��
function DeleteClickHandler(){
	if (SelectRow1!="-1"){
		var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections')
		if (rowdata){
			var FavRowid=rowdata[0].FavRowid;
			var ReturnValue=tkMakeServerCall("web.DHCUserFavItems","DeleteUserARCOS",FavRowid);
			if (ReturnValue=='-1') {
				$.messager.alert('��ʾ','ɾ��ҽ����ʧ��.');  
			}else{
				$.messager.popover({msg: 'ɾ��ҽ���׳ɹ�!',type:'success'});
				//��Ҫ����ղ�ѯ����
				ClearARCOSInfo(true);
				LoadUDHCFavOrderSetsEditDataGrid();
			}
		}
	}else{
		$.messager.alert('��ʾ','��ѡ����Ҫɾ����ҽ����');    
	}	
}
//ҽ���׸���
function UpdateClickHandler()
{
	if ((ARCOSRowid=="")||(SelectRow1=="-1")){
		$.messager.alert('��ʾ','��ѡ����Ҫ���µ�ҽ����!');
		return;
	}
	//ȷ����ѡ��״̬��ȥȡֵ
	var Contions=getValue("Conditiones"); //$('#Conditiones').combobox('getValue')
	if ((Contions=="")&&(SaveType!="SaveToUser")){
		$.messager.alert('��ʾ','����Ϊ��ѡ��,��ѡ��!');
		return false;
	}
	var UserID=session['LOGON.USERID']
	var UserCode=session["LOGON.USERCODE"];
	var GroupID=session['LOGON.GROUPID'];
	var	CTLOCID=session['LOGON.CTLOCID'];
	var HospID=""
	var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSCatID=$('#Category').combobox('getValue');
	var ARCOSSubCatID=$('#SubCategory').combobox('getValue')
	var Data=$('#SubCategory').combobox("getData");
	var ARCOSSubCatID1=""
	for (var i=0;i<Data.length;i++) {
		if (Data[i] && Data[i].CombValue==ARCOSSubCatID) {
    	    ARCOSSubCatID1=Data[i] && Data[i].CombValue
		}
	}
	ARCOSSubCatID=ARCOSSubCatID1
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelected');
	var FavRowid=rowdata['FavRowid'] //$("#FavRowid").val();
	if ((FavRowid!="")&&(FavRowid!=undefined)){
		FavRowid=FavRowid.replace(/(^\s*)|(\s*$)/g,'');
	}
	var ARCOSEffDateFrom=NowDate
	var FavDepList=CTLOCID;
	var DocMedUnit="";
	if ($('#CelerType').checkbox("getValue")){
		var CelerType="Y";
	}else{
		var CelerType="N";
	}
	if((CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0)&&(CelerType=="Y")){
		$.messager.alert('��ʾ','��ҩҽ�����ݲ�֧�ֿ���¼�룡'); 
		return;
	}
	if ((CMFlag=="Y")&&(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")<0)) {
		$.messager.alert('��ʾ','��ѡ���ҩ��ص�ҽ��������!'); 
		return;
	}
	if ((CMFlag=="N")&&(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>=0)) {
		$.messager.alert('��ʾ','��ѡ����ҩ��ص�ҽ��������!'); 
		return;
	}
	if (FavRowid==""){
		$.messager.alert('��ʾ','û��ȡ�ø���ҽ����Rowid!'); 
		return;
	}
	if (ARCOSDesc==""){
		$.messager.alert('��ʾ','ҽ�������Ʋ���Ϊ��,���������!'); 
		return;
	}
	if (ARCOSAlias==""){
		$.messager.alert('��ʾ','ҽ���ױ�������Ϊ��,����ӱ���!'); 
		return;
	}
	if (ARCOSCode=='') {
		$.messager.alert('��ʾ','ҽ���״��벻��Ϊ��,����д����!');
		return;
	}
	if (UserID==""){
		$.messager.alert('��ʾ','ȱ���û���Ϣ,��ˢ�½������µ�½���ٴγ���!'); 
		return;
	}
	if (ARCOSCatID==""){
		$.messager.alert('��ʾ','��ѡ����Ӧ��ҽ���״���!'); 
		return;
	}
	if (ARCOSSubCatID==""){
		$.messager.alert('��ʾ','��ѡ����Ӧ��ҽ��������!'); 
		return;
	}
	
	//ȡ��
	var DocMedUnit=tkMakeServerCall("web.DHCUserFavItems","GetMedUnit",UserID,CTLOCID);
	var FavDepList="";
	var InUser=UserID;
	//�����ж��������ֵ
	if (Contions=="1"){
		FavDepList="";DocMedUnit="";
		//ҽ���׵�����Ҫ����Code
		if (ARCOSDesc.indexOf("-")<0){
			ARCOSDesc=UserCode+"-"+ARCOSDesc;
		}
	}else if (Contions=="2"){
		InUser="";FavDepList=CTLOCID;DocMedUnit=""
	}else if(Contions=="3"){
		InUser="";FavDepList="";DocMedUnit="";
		HospID=session['LOGON.HOSPID']
	}else if(Contions=="4"){
		FavDepList="";
		if (DocMedUnit==''){
			$.messager.alert('��ʾ','��û�б����뵽��½������Ч������,���ܽ��и���������');
			return;
		}
	}
	var Desc=ARCOSDesc;
	if (ARCOSDesc.indexOf("-")>=0){
		Desc=ARCOSDesc.split("-").slice(1).join("-");
	}
	var Spell=tkMakeServerCall("ext.util.String","ToChineseSpell",Desc);
	if ((ARCOSAlias!="")&&(ARCOSAlias!=Spell)){
		if (dhcsys_confirm("�Ƿ񽫱����滻Ϊ"+Spell+"?")){
			$("#Alias").val(Spell);
			ARCOSAlias=Spell;
		}
	}
	
	var Err=tkMakeServerCall("web.DHCUserFavItems","UpdateUserARCOS",FavRowid,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffDateFrom,ARCOSAlias,FavDepList,DocMedUnit,InUser,HospID,CelerType)
	if (Err=='-1') {
		$.messager.alert('��ʾ','����ʧ��');
		return;
	}else if (Err=='-2') {
		$.messager.alert('��ʾ','��������д���Ѿ�ʹ�õĴ���');
		return;
	}else if (Err=='-3') {
		$.messager.alert('��ʾ','ԭҽ������ά���������ͻ���ά����ϸ���ݲ����޸�Ϊ�ǲ�ҩҽ����!');
		return;
	}else if (Err=='-4') {
		$.messager.alert('��ʾ','ԭҽ������ά����ϸ���ݲ����޸�Ϊ��ҩҽ����!');
		return;
	}else{
		$.messager.popover({msg: '���³ɹ�!',type:'success'});
		CloseWindow(ARCOSRowid);
		
		LoadUDHCFavOrderSetsEditDataGrid();	
	}
}
function SaveAsUserClickHandler(e){
	if (SelectRow1!="-1"){
		if (ForQueryLoc==""){
			$.messager.alert('��ʾ','�ǿ���ģ�岻�ܱ���Ϊ����');
			return
		}
		AddClickHandler("SaveToUser")
	}else{
		$.messager.alert('��ʾ','��ѡ��ҽ����');    
	}
	
}
//��ʼ��Comb
function CombListCreat(){
	//����Comb
	CategoryCombCreat()
	//��ʼ������
	ConditionesCombCreat()
}
function ConditionesCombCreat(){
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"Conditiones", 
		rows:99999
	},false);
	var cbox = $HUI.combobox("#Conditiones", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(data){
				$(this).combobox('select',data[0]['CombValue']);
			},onSelect:function(record){
				//����ΪȫԺ ��û��Ȩ���޸�ȫԺҽ����
				if ((record["CombValue"]=="3")&&(HospARCOSAuthority!="1")){
					UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:[]});
					UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:[]});
					ModifyHospArcosFlag=0;
				}else{
					UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:ARCOSToolBar});
					UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:ARCOSItemToolBar});
					ModifyHospArcosFlag=1;
				}
				LoadUDHCFavOrderSetsEditDataGrid();
			}
	 });
}
//��ʼ������
function CategoryCombCreat(){
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"Category", 
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#Category", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(data){
				for (var i=0;i<data.length;i++){
			        if (data[i]['CombDesc'].indexOf("ҽ����")>=0){
				        $('#Category').combobox('select',data[i]['CombValue']);
				        break;
				    }
			    }
		       //����������֮��
		       SubCategoryCombCreat()
		       var Category=$('#Category').combobox('getText');
			   if (Category.indexOf("ҽ����")>=0){
				   	$('#Category').combobox('disable')
				   	DfaultCatID=$('#Category').combobox('getValue');
			   }
			},onSelect:function(record){
				//ѡ�����  
           		SubCategoryCombCreat()
			}
		 });
	});
	
}
//��ʼ������
function SubCategoryCombCreat()
{
	var CategoryID=$('#Category').combobox('getValue');
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"SubCategory",Inpute1:CategoryID,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#SubCategory", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"]
	   });
	});
	
}
//ѡ��ҽ����---
function SelectARCOSDataFromRow(){	
	var ARCOSCode="",ARCOSDesc="",ARCOSAlias="";ARCOSOrdSubCatDR="",ARCOSOrdCatDR=DfaultCatID,ForQueryLoc="",FavUserDr="",FavDepDr="",MedUnit="",CelerType="N"
	var FavRowid=""
	if (SelectRow1!="-1"){
		//ҽ����ֻ����ѡ���rowdata[0]
		var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections')
		if (rowdata){
			ARCOSCode=rowdata[0].ARCOSCode;
			ARCOSDesc=rowdata[0].ARCOSDesc;
			ARCOSAlias=rowdata[0].ARCOSAlias;
			ARCOSOrdSubCatDR=rowdata[0].ARCOSOrdSubCatDR;
			ARCOSOrdCatDR=rowdata[0].ARCOSOrdCatDR;
			ForQueryLoc=rowdata[0].FavDepDr;
			FavRowid=rowdata[0].FavRowid;
			FavUserDr=rowdata[0].FavUserDr;
			FavDepDr=rowdata[0].FavDepDr;
			MedUnit=rowdata[0].MedUnit;
			CelerType=rowdata[0].CelerType;
		}
	}
	if ((ARCOSOrdSubCatDR!="")&&(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1)){
		$HUI.checkbox('#CelerType').disable();
	}else{
		$HUI.checkbox('#CelerType').enable();
	}
	$("#Code").val(ARCOSCode);
	$("#Desc").val(ARCOSDesc);
	$("#Alias").val(ARCOSAlias);
	$('#SubCategory').combobox('setValue',ARCOSOrdSubCatDR);
	$('#Category').combobox('setValue',ARCOSOrdCatDR);
	$("#FavRowid").val(FavRowid);
	if (CelerType=="Y"){
		$("#CelerType").checkbox('check');
	}else{
		$("#CelerType").checkbox('uncheck');
	}
	if(SelectRow1=="-1"){
		$('#Conditiones').combobox('setValue','');
		$('div.datagrid-toolbar a').eq(1).show();
		$('div.datagrid-toolbar div').eq(1).show();
	}else{
		if(FavUserDr!=""){
		  $('#Conditiones').combobox('setValue',1);
	    }
	    if(FavDepDr!=""){
		  $('#Conditiones').combobox('setValue',2);
	    }
	    if((MedUnit!="")||((FavDepDr=="")&&(FavUserDr=="")&&(MedUnit==""))){
		  $('#Conditiones').combobox('setValue',3);
	    }
	}
}
function LoadDataForFav(){
	ARCOSToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
               AddClickHandler();
            }
        },{
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
               DeleteClickHandler();
            }
        },{
            text: '�޸�',
            iconCls: 'icon-edit',
            handler: function() {
			  UpdateClickHandler();
            }
        },
        '-', {
            text: '���Ϊ����ҽ����',
            iconCls: 'icon-save',
            handler: function() {
                SaveAsUserClickHandler();
            }
        },
        '-', {
            text: '��װ�۸�',
            iconCls: 'icon-mnypaper-cfg',
            handler: function() {
	            if(window){
					  var obj =window.dialogArguments
					  if(obj){
						  $.messager.alert('��ʾ','ģ̬���ڲ�֧��,�뵽��Ӧ���ܲ˵��´���!');
			              return
					  } 
				}
                OrdSetPriceClickHandler();
            }
        },'-', {
            text: '����ά��',
            iconCls: 'icon-tip',
            handler: function() {
	            if(window){
					  var obj =window.dialogArguments
					  if(obj){
						  $.messager.alert('��ʾ','ģ̬���ڲ�֧��,�뵽��Ӧ���ܲ˵��´���!');
			              return
					  } 
				}
                OtherARCAlias();
            }
        },'-', {
            text: '��Ȩ�����ÿ���',
            iconCls: 'icon-batch-cfg',
            handler: function() {
	            if(window){
					  var obj =window.dialogArguments
					  if(obj){
						  $.messager.alert('��ʾ','ģ̬���ڲ�֧��,�뵽��Ӧ���ܲ˵��´���!');
			              return
					  } 
				}
                AuthorizeSetWinClick();
            }
        },{
            text: '����ҽ����',
            iconCls: 'icon-copy',
            handler: function() {
	            if(window){
					  var obj =window.dialogArguments
					  if(obj){
						  $.messager.alert('��ʾ','ģ̬���ڲ�֧��,�뵽��Ӧ���ܲ˵��´���!');
			              return
					  } 
				}
                websys_showModal({
					url:"udhcfavitem.copy.csp",
					title:'����ҽ����',
					width:'90%',height:'90%',
					onClose:function(){
						LoadUDHCFavOrderSetsEditDataGrid();
					}
				})
            }
        },'-',{
	        text: '���浽ҽ��ģ��',
            iconCls: 'icon-save',
            handler: function() {
	            if (!ARCOSRowid) {
		            $.messager.alert("��ʾ","��ѡ����Ҫ���浽ҽ��ģ���ҽ���ף�");
		            return false;
		        }
		        var Type="��ҩ";
		        var index = $('#UDHCFavOrderSetsEdit').datagrid('getRowIndex', ARCOSRowid);
		        var rows = $('#UDHCFavOrderSetsEdit').datagrid('getRows');
				var ARCOSOrdSubCatDR=rows[index].ARCOSOrdSubCatDR;
				if(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1){	//���в�ҩҽ����
					Type="��ҩ";
				}
				OpenOrdTemplateWin(Type,ARCOSRowid);
            }
	    }/*,
        '-', {
            text: '���浽����ҽ��ģ��',
            iconCls: 'icon-save',
            handler: function() {
                SaveToUserFavClick();
            }
        }*/
		];
	//ҽ����
	UDHCFavOrderSetsEditDataGrid=$('#UDHCFavOrderSetsEdit').datagrid({  
		width : 'auto',
		fit:true,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		url:$URL+"?ClassName=web.DHCUserFavItems&QueryName=FindUserOrderSet",
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : true,  //
		idField:"ARCOSRowid",
		pageSize:10,
		pageList : [10,50,100],
		toolbar :ARCOSToolBar,
		//frozenColumns : FrozenCateColumns,
		columns :[[
			{field:'CheckArcos',title:'ѡ��',hidden:true},
			{field:'ARCOSOrdCat',title:'����',width:80,align:'left'},
			{field:'ARCOSOrdSubCat',title:'����',width:100,sortable:true,
				sorter:function(a,b){  
					debugger;
				}
			},
			{field:'ARCOSCode',title:'����',width:100,sortable:true},   
			{field:'ARCOSDesc',title:'����',width:150,sortable:true},   
			{field:'ARCOSAlias',title:'����',width:100,sortable:true},
			{field:'CelerType',title:'����',width:50,sortable:true},
			{field:'FavUserDesc',title:'�û�',width:80,sortable:true},
			{field:'FavDepDesc',title:'ʹ�ÿ���',width:100,sortable:true},
			{field:'ARCOSAddUser',title:'������',width:80,sortable:true},
			{field:'ARCOSAddDate',title:'����ʱ��',width:115,sortable:true},
			{field:'MedUnitDesc',title:'����',width:100,hidden:true},
			
			{field:'ARCOSRowid',title:'ARCOSRowid',width:100,hidden:true},   
			{field:'ARCOSOrdSubCatDR',title:'ARCOSOrdSubCatDR',width:100,hidden:true}, 
			{field:'ARCOSEffDateFrom',title:'��Ч����',width:100,hidden:true}, 
			{field:'FavRowid',title:'FavRowid',width:100,hidden:true}, 
			{field:'ARCOSOrdCatDR',title:'ARCOSOrdCatDR',width:100,hidden:true}, 
			{field:'FavUserDr',title:'�û�ID',width:100,hidden:true}, 
			{field:'FavDepDr',title:'����ID',width:100,hidden:true}, 
			{field:'MedUnit',title:'��',width:100,hidden:true},
			{field:'PrescTypeCode',hidden:true},
	        {field:'DuratId',hidden:true},
	        {field:'FreqId',hidden:true},
	        {field:'InstrId',hidden:true},
	        {field:'DosageId',hidden:true},
	        {field:'Notes',hidden:true}
		 ]],
		onSelect:function(rowid,RowData){
    		//ѡ��ҽ���׸�ֵ
			if (SelectRow1==rowid){
				SelectRow1="-1"
				ARCOSRowid=""
				$(this).datagrid('unselectRow', rowid); 
				ModifyHospArcosFlag=1;
				/*UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:ARCOSToolBar});
		        UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:ARCOSItemToolBar});*/
		        $(".datagrid-toolbar").show();
				ControlPanel();
			}else{
				ARCOSRowid=RowData.ARCOSRowid;
				SelectRow1=rowid;
				if (HospARCOSAuthority=="1"){
					if ((RowData.FavUserDr==session['LOGON.USERID'])||(RowData.FavDepDr==session['LOGON.CTLOCID'])||(RowData.FavUserDr=="" && RowData.FavDepDr=="")){
						ModifyHospArcosFlag=1;
						$(".datagrid-toolbar").show();
					}else{
						ModifyHospArcosFlag=0;
						$(".datagrid-toolbar").hide();
					}
				}else{
					if (((RowData.FavUserDr=="")&&(RowData.FavDepDr=="")&&(RowData.MedUnit==""))&&(HospARCOSAuthority!="1")) {
						ModifyHospArcosFlag=0;
						$(".datagrid-toolbar").hide();
						/*UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:[]});
						UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:[]});*/
					}else{
						ModifyHospArcosFlag=1;
						$(".datagrid-toolbar").show();
						/*UDHCFavOrderSetsEditDataGrid.datagrid({toolbar:ARCOSToolBar});
				        UDHCARCOrderSetItemEditDataGrid.datagrid({toolbar:ARCOSItemToolBar});*/
					}
				}
				ControlPanel(rowid, RowData);
			}
			SelectARCOSDataFromRow()
			LoadUDHCARCOrderSetItemEditDataGrid();
		},
		onBeforeLoad:function(param){
			$('#UDHCFavOrderSetsEdit').datagrid("uncheckAll");
			//����֮ǰ���ѡ����Ϣ
			ARCOSRowid=""; //ҽ����ID
			SelectRow1="-1"; //ѡ��ҽ������ -1��ʾδѡ��
			var data=$('#Conditiones').combobox('getData');
			if (data.length==0) return false;
			var Contions=$('#Conditiones').combobox('getValue');
			if (Contions==undefined) Contions="";
			var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
			var ARCOSSubCatID=$('#SubCategory').combobox('getValue');
			var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
			var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
			var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
			var ARCOSCatID=$('#Category').combobox('getValue');
			var ARCOSSubCatID=$('#SubCategory').combobox('getValue')
			var ARCOSEffDateFrom=NowDate
			var FavDepList=session['LOGON.CTLOCID'];
			var DocMedUnit=""
			if ((Contions=="")&&(ARCOSDesc=="")&&(ARCOSAlias=="")&&(HospARCOSAuthority==0)){
				$.messager.alert("��ʾ","����Ϊ��ʱ,�����ͱ�������ͬʱΪ��!","info",function(){
					$("#Desc").focus();
				})
				return false;
			}
			var CelerType=$("#CelerType").checkbox('getValue')?"Y":"N";
			$.extend(param,{
				UserID:session['LOGON.USERID'],
				QueryFlag:"",ForQueryUserID:"",ForQueryLocID:"",status:"",
				Conditiones:Contions,
				DocMedUnit:"",
				subCatID:ARCOSSubCatID, Code:ARCOSCode, 
				Desc:ARCOSDesc, Alias:ARCOSAlias,
				LogonHospID:session['LOGON.HOSPID'],
				HospARCOSAuthority:HospARCOSAuthority,
			    paraCelerType:CelerType
			});
		},
		onLoadSuccess:function(data){
			LoadUDHCARCOrderSetItemEditDataGrid();
			ControlPanel();
		}
	})//.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});	
	ARCOSItemToolBar = [{
            text: '����',
            iconCls: 'icon-add',
            handler: function() { 
               LAddClickHandler();
            }
        }, {
            text: 'ɾ��',
            iconCls: 'icon-cancel',
            handler: function() {
               LDeleteClickHandler();
            }
        },{
            text: '�޸�',
            iconCls: 'icon-edit',
            handler: function() {
			  LUpdateClickHandler();
            }
        },
        '-', {
            text: '����',
            iconCls: 'icon-arrow-top',
            handler: function() {
                upClick();
            }
        },{
            text: '����',
            iconCls: 'icon-arrow-bottom',
            handler: function() {
                dwClick();
            }
        }];
	//ҽ������ϸ��Ϣ
	UDHCARCOrderSetItemEditDataGrid=$('#UDHCARCOrderSetItemEdit').datagrid({  
		width : 'auto',
		fit:true,
		//height: $("#UDHCARCOrderSetItemEditLay").height()-420,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : true,
		//url : '',
		loadMsg : '������..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"NO", //ARCOSItemRowid
		pageSize:6,
		pageList : [6,15,50,100],
		toolbar :ARCOSItemToolBar,
		style:{
			"border-top":"1px solid #ccc"
		},
		//frozenColumns : FrozenCateColumns,
		columns :[[
			{field:'NO',title:'���',width:50},
			{field:'ARCIMDesc',title:'����',width:300,align:'left'}, 
			{field:'ARCOSItemDoseQty',title:'����',width:100},
			{field:'ARCOSItemUOM',title:'������λ',width:100},
			{field:'ARCOSItemFrequence',title:'Ƶ��',width:100},
			{field:'ARCOSItemInstruction',title:'�÷�',width:100},
			{field:'ARCOSItemDuration',title:'�Ƴ�',width:50},  
			{field:'ARCOSItemQty',title:'����',width:60},   
			{field:'ARCOSItemBillUOM',title:'��λ',width:50},
			{field:'ARCOSItmLinkDoctor',title:'����',width:50},
			{field:'Tremark',title:'��ע',width:150},
			{field:'ARCOSDHCDocOrderType',title:'ҽ������',width:100},
			{field:'SampleDesc',title:'�걾',width:100},
			{field:'OrderPriorRemarks',title:'����˵��',width:100},
			{field:'DHCDocOrdRecLoc',title:'���տ���',width:200},
			{field:'DHCDocOrdStage',title:'ҽ���׶�',width:150},
			{field:'DHCMustEnter',title:'�ؿ���',width:80},
			{field:'SpeedFlowRate',title:'��Һ����',width:80},
			{field:'FlowRateUnit',title:'���ٵ�λ',width:85},
			{field:'ARCOSItemRowid',title:'ARCOSItemRowid',width:100,hidden:true},   
			{field:'ARCIMRowid',title:'ARCIMRowid',width:100,hidden:true}, 
			{field:'ARCOSItemUOMDR',title:'ARCOSItemUOMDR',width:100,hidden:true}, 
			{field:'ARCOSItemFrequenceDR',title:'ARCOSItemFrequenceDR',width:100,hidden:true}, 
			{field:'ARCOSItemDurationDR',title:'ARCOSItemDurationDR',width:100,hidden:true}, 
			{field:'ARCOSItemInstructionDR',title:'ARCOSItemInstructionDR',width:100,hidden:true}, 
			{field:'ARCOSDHCDocOrderTypeDR',title:'ARCOSDHCDocOrderTypeDR',width:100,hidden:true}, 
			{field:'SampleID',title:'SampleID',width:100,hidden:true}, 
			{field:'ITMSerialNo',title:'ITMSerialNo',width:100,hidden:true}, 
			{field:'OrderPriorRemarksDR',title:'OrderPriorRemarksDR',width:100,hidden:true}
		
		 ]],
    	onDblClickRow:function(rowid,RowData){
    	    if (ModifyHospArcosFlag=="0") return false;
    		//����˫���༭�¼�
    		var EARCOSItemRowid=RowData.ARCOSItemRowid;
    		if (EARCOSItemRowid!=""){
	    		var ARCIMRowid=RowData.ARCIMRowid;
				OpenArcosEditWindow(ARCOSRowid,EARCOSItemRowid,ARCIMRowid);
    		}
		}
	});	
}
//����ҽ����Data
function LoadUDHCFavOrderSetsEditDataGrid(){
	$('#UDHCFavOrderSetsEdit').datagrid("reload");
	return;
	//����֮ǰ���ѡ����Ϣ
	ARCOSRowid=""; //ҽ����ID
	SelectRow1="-1"; //ѡ��ҽ������ -1��ʾδѡ��
	var Contions=$('#Conditiones').combobox('getValue');
	if (Contions==undefined) Contions="";
	var UserID=session['LOGON.USERID']
	var UserCode=session["LOGON.USERCODE"];
	var GroupID=session['LOGON.GROUPID'];
	var	CTLOCID=session['LOGON.CTLOCID'];
	var ARCOSCode=$("#Code").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSDesc=$("#Desc").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSAlias=$("#Alias").val().replace(/(^\s*)|(\s*$)/g,'');
	var ARCOSCatID=$('#Category').combobox('getValue');
	var ARCOSSubCatID=$('#SubCategory').combobox('getValue')
	var ARCOSEffDateFrom=NowDate
	var FavDepList=CTLOCID;
	var DocMedUnit=""
	if ((Contions=="")&&(ARCOSDesc=="")&&(ARCOSAlias=="")&&(HospARCOSAuthority==0)){
		$.messager.alert("��ʾ","����Ϊ��ʱ,�����ͱ�������ͬʱΪ��!","info",function(){
			$("#Desc").focus();
		})
		return false;
	}
	var CelerType=$("#CelerType").checkbox('getValue')?"Y":"N";
	$.cm({
	    ClassName : "web.DHCUserFavItems",
	    QueryName : "FindUserOrderSet",
	    UserID:UserID, QueryFlag:"", ForQueryUserID:"", 
	    ForQueryLocID:"", status:"", Conditiones:Contions, 
	    DocMedUnit:"", subCatID:ARCOSSubCatID, Code:ARCOSCode, 
	    Desc:ARCOSDesc, Alias:ARCOSAlias, LogonHospID:session['LOGON.HOSPID'], HospARCOSAuthority:HospARCOSAuthority,
	    paraCelerType:CelerType,
	    Pagerows:UDHCFavOrderSetsEditDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		UDHCFavOrderSetsEditDataGrid.datagrid("uncheckAll").datagrid('loadData',GridData);
		LoadUDHCARCOrderSetItemEditDataGrid();
		ControlPanel();
	})
}
//����ҽ������ϸ��Ϣ
function LoadUDHCARCOrderSetItemEditDataGrid(type)
{
	if($('#UDHCARCOrderSetItemEdit').length<=0){return}
	
	if (typeof(type) == "undefined") type="";
	UDHCARCOrderSetItemEditDataGrid.datagrid('unselectAll');
	var QueryFlag=""
	if (ARCOSRowid!=""){QueryFlag=1}
	$.cm({
	    ClassName : "web.DHCARCOrdSets",
	    QueryName : "FindOSItem",
	    ARCOSRowid:ARCOSRowid, QueryFlag:QueryFlag,
	    Pagerows:UDHCARCOrderSetItemEditDataGrid.datagrid("options").pageSize,rows:99999
	},function(GridData){
		UDHCARCOrderSetItemEditDataGrid.datagrid({loadFilter:DocToolsHUI.lib.pagerFilter}).datagrid('loadData',GridData);
		//�����ҽ����ϸά��������������ϸ�����Զ���ת�����һҳ�����һ����¼
		if (type!=""){
			var total=parseInt(UDHCARCOrderSetItemEditDataGrid.datagrid('getData').total);
			var pageSize=parseInt(UDHCARCOrderSetItemEditDataGrid.datagrid("options").pageSize);
			var LastPage=Math.ceil(total/pageSize);
			if (LastPage>1){
				UDHCARCOrderSetItemEditDataGrid.datagrid('getPager').pagination('select',LastPage); //��ת�����һҳ
				var LastPageData=UDHCARCOrderSetItemEditDataGrid.datagrid('getData');
				UDHCARCOrderSetItemEditDataGrid.datagrid("scrollTo",LastPageData.rows.length-1)
			}else{
				UDHCARCOrderSetItemEditDataGrid.datagrid("scrollTo",total-1);
			}
		}
	})
}
//ҽ������ϸ�۵�
function ItemEditLayStyle(){
	if (ItemEditLay=="Y"){ItemEditLay="N"}else{ItemEditLay="Y"}
	if (ItemEditLay=="N"){
		//���¶����ҳ��������
		UDHCARCOrderSetItemEditDataGrid=$('#UDHCFavOrderSetsEdit').datagrid({pageList:[20]})
		LoadUDHCFavOrderSetsEditDataGrid()
	}else{
		UDHCARCOrderSetItemEditDataGrid=$('#UDHCFavOrderSetsEdit').datagrid({pageList:[10]})
		LoadUDHCFavOrderSetsEditDataGrid()
	}
}
//ҽ�����۵�
function UDHCFavStyle()
{
	//��������۵�״̬
	if (FavEditLay=="Y"){FavEditLay="N"}else{FavEditLay="Y"}
	if (FavEditLay=="N"){
		//���¶����ҳ��������
		UDHCARCOrderSetItemEditDataGrid=$('#UDHCARCOrderSetItemEdit').datagrid({pageList:[20]})
		LoadUDHCARCOrderSetItemEditDataGrid()
	}else{
		UDHCARCOrderSetItemEditDataGrid=$('#UDHCARCOrderSetItemEdit').datagrid({pageList:[6]})
		LoadUDHCARCOrderSetItemEditDataGrid()
	}
	
}
//RowID����ѡѡ����--֧�ֵ��з�ҳѡ��
function SetSelectRow(RowID)
{
	var pageObj=$('#UDHCARCOrderSetItemEdit').datagrid('getPager');
	var Options=$(pageObj).pagination('options')
	var Total=Options.total; //������
	var pageSize=Options.pageSize; //ÿҳ����
	var pageNumber=Options.pageNumber; //��ǰҳ
	var PageNum=Math.ceil(Total/pageSize) //����ȡ��
	var FindPage=""
	$(pageObj).pagination({
		onSelectPage:function(pageNumber, pageSize){
			//alert(pageSize)
			//return true
		}
	});

	for (var KPage=1;KPage<=PageNum;KPage++){
		if (FindPage!=""){break}
	}
}
function upClick(){
	Mouvw("up")
}
function dwClick(){
	Mouvw("dw")
}
function Mouvw(Type){
	var row = UDHCARCOrderSetItemEditDataGrid.datagrid('getSelected');
    var index = UDHCARCOrderSetItemEditDataGrid.datagrid('getRowIndex', row);
    var rows = UDHCARCOrderSetItemEditDataGrid.datagrid('getRows').length;
	if (Type=="up"){
		if (index != 0) {
			var toup = UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index];
            var todown = UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index - 1];
            
            var TopNO=toup.NO; 
            var TopARCOSItemNO=toup.ITMSerialNo; 
            
            var DwNO=todown.NO;
            var DwARCOSItemNO=todown.ITMSerialNo;
            
            todown.NO=TopNO;
            todown.ITMSerialNo=TopARCOSItemNO;
            
            toup.ITMSerialNo=DwARCOSItemNO;
            toup.NO=DwNO;
            
            UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index] = todown;
            UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index - 1] = toup;
            UDHCARCOrderSetItemEditDataGrid.datagrid('refreshRow', index);
            UDHCARCOrderSetItemEditDataGrid.datagrid('refreshRow', index - 1);
            UDHCARCOrderSetItemEditDataGrid.datagrid('selectRow', index - 1);
            var rtn=UpdateSerialNO(todown.ARCOSItemRowid,todown.ITMSerialNo,todown.ARCIMRowid)
            var rtn=UpdateSerialNO(toup.ARCOSItemRowid,toup.ITMSerialNo,toup.ARCIMRowid)
		}
	}else if (Type=="dw"){
		  if (index != rows - 1){
			var todown = UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index];
            var toup = UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index + 1];
            var TopNO=toup.NO; 
            var TopARCOSItemNO=toup.ITMSerialNo;
            
            var DwARCOSItemNO=todown.ITMSerialNo;
            var DwNO=todown.NO;
            
            todown.NO=TopNO;;
            todown.ITMSerialNo=TopARCOSItemNO;
            
            toup.NO=DwNO;
            toup.ITMSerialNo=DwARCOSItemNO;
         
            UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index + 1] = todown;
            UDHCARCOrderSetItemEditDataGrid.datagrid('getData').rows[index] = toup;
            UDHCARCOrderSetItemEditDataGrid.datagrid('refreshRow', index);
            UDHCARCOrderSetItemEditDataGrid.datagrid('refreshRow', index + 1);
            UDHCARCOrderSetItemEditDataGrid.datagrid('selectRow', index + 1);
            var rtn=UpdateSerialNO(todown.ARCOSItemRowid,todown.ITMSerialNo,todown.ARCIMRowid)
            var rtn=UpdateSerialNO(toup.ARCOSItemRowid,toup.ITMSerialNo,toup.ARCIMRowid)
		}
	}	
}
///��������
function UpdateSerialNO(ARCOSItemRowid,SerNO,arcimid){	
	 var rtn=tkMakeServerCall("web.DHCARCOrdSets","UpdateItemSerialNo",ARCOSItemRowid,SerNO,arcimid)
	 return rtn	
}
//���ҽ���ײ�ѯ����
function ClearARCOSInfo(IsClearList){
	if (IsClearList) {
		$('#SubCategory').combobox('setValue','');
		//$('#Category').combobox('setValue','');
		$('#Conditiones').combobox('select','1');
	}
	$("#Code").val("");
	$("#Desc").val("");
	$("#Alias").val("");
	$("#FavRowid").val("");
	$("#CelerType").checkbox('uncheck');
	$HUI.checkbox('#CelerType').enable();
}
//��װ�۸�
function OrdSetPriceClickHandler() {
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections')
	if ((rowdata)&&(rowdata.length!=0)){
		ARCOSRowid=rowdata[0].ARCOSRowid;
		var src="doc.favitemprice.hui.csp?ARCOSRowid="+ARCOSRowid;   
		if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
		var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
		createModalDialog("ARCOSEdit","��װ�۸�ά��", 1130, 500,"icon-w-inv","",$code,"")
	}else{
		$.messager.alert('��ʾ','��ѡ��һ��ҽ����!');
	}
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        setTimeout(function(){destroyDialog(id);});
	    }
    });
}
function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}
function ControlPanel(rowIndex, rowData)
{
	var ARCOSOrdSubCatDR="";
	if(rowData) ARCOSOrdSubCatDR=rowData.ARCOSOrdSubCatDR;
	var jqPanle=$('#main').layout('panel','east');
	if(CNMedItemCatStr.indexOf("^"+ARCOSOrdSubCatDR+"^")>-1){	//���в�ҩҽ����
		if(jqPanle.panel("options").collapsed){
			$('#main').layout('expand','east');
		}
		InitOSCNInfo(rowData);	//��ʼ���в�ҩ������Ϣ ������������ο�dhcdoc.ordsets.edit.js
	}else{
		if(!jqPanle.panel("options").collapsed){
			$('#main').layout('collapse','east');
		}
	}
}
function InitOSCNInfo(rowData)
{
	var PrescTypeCode=rowData.PrescTypeCode;
    var DurRowid=rowData.DuratId;
    var FreqRowid=rowData.FreqId;
    var QtyID=rowData.DosageId;
    var InstrRowid=rowData.InstrId;
    var Notes=rowData.Notes;
    var SyndromeCICDDesc=rowData.SyndromeCICDDesc;
	var SyndromeCICDRowid=rowData.SyndromeCICDRowid;
	if (CNPrescTypeArr==""){
		InitCMCombo();
	}
	//ֻ����������ѡ��Ĵ�������
	var newCNPrescTypeArr=[];
    for(var i=0;i<CNPrescTypeArr.length;i++){
        var CatStr=CNPrescTypeArr[i].id.split("#")[5];
        if(("^"+CatStr+"^").indexOf("^"+rowData.ARCOSOrdSubCatDR+"^")>-1){
	    	newCNPrescTypeArr[newCNPrescTypeArr.length]=CNPrescTypeArr[i];
	    }
    }
    $("#PrescTypeComb").combobox('loadData',newCNPrescTypeArr);
    var PrescTypeCodeId="" //newCNPrescTypeArr[0].id;
    if(PrescTypeCode!=""){
	    for(var i=0;i<newCNPrescTypeArr.length;i++){
		    if(newCNPrescTypeArr[i].id.split("#")[0]==PrescTypeCode){
			    PrescTypeCodeId=newCNPrescTypeArr[i].id;
			}
		}
	}
    if((DurRowid!="")||(FreqRowid!="")||(InstrRowid!="")||(QtyID!="")){
	    $("#PrescTypeComb").combobox('setValue',PrescTypeCodeId);
    	SetCMInfo(DurRowid,FreqRowid,InstrRowid,QtyID)
    }else{
	     //PrescTypeChange();
	     $("#PrescTypeComb").combobox('select',PrescTypeCodeId);
	}
	InitPrescNotes();
    $('#CNNote').val(Notes);
}
function InitCMCombo(){
    InitSingleCombo('DoseQtyComb','Code','Desc','DHCDoc.DHCDocConfig.CMDocConfig','FindInstrLinkOrderQty')
    if (CNFreqArr==""){
	    CNFreqArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpFrequence", IdCol:5, TextCol:1, CodeCol:2
		},false);
	    InitLocalCombo('FreqComb',CNFreqArr);
	    CNDurationArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpDuration", IdCol:1, TextCol:2, CodeCol:4
		},false);
	    InitLocalCombo('DurationComb',CNDurationArr);
	    CNInstrArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteQueryJson",
			className:"web.DHCDocOrderEntryCM", queryName:"LookUpInstr", IdCol:1, TextCol:2, CodeCol:3
		},false);
	    InitLocalCombo('InstrComb',CNInstrArr);
	    InitLocalCombo('PrescTypeComb',[]);
	    CNPrescTypeArr=$.cm({
			ClassName:"DHCDoc.DHCDocConfig.OrdSets",
			MethodName:"WriteCNPrescType"
		},false);
    }
}
function InitSingleCombo(id,valueField,textField,ClassName,QueryName)
{
	var ComboObj={
		editable:false,
		multiple:false,
		selectOnNavigation:true,
	  	valueField:valueField,   
	  	textField:textField,
	  	url:$URL+'?ClassName='+ClassName+'&QueryName='+QueryName
	};
	if(id=='DoseQtyComb'){
	    $.extend(ComboObj,{ 
	    	editable:false, 
		    panelHeight:'auto',
            onBeforeLoad:function(param){
	            var InstrucRowId=$('#InstrComb').combobox('getValue');
	            param = $.extend(param,{InstrucRowId:InstrucRowId});
            },
            loadFilter:function(data){
	            return data['rows'];
	        }
        });
	}
	$("#"+id).combobox(ComboObj);
}
function InitLocalCombo(id,data)
{
    var ComboObj={
		editable:false,
		panelHeight:'auto',
		multiple:false,
		selectOnNavigation:true,
	  	valueField:'id',   
        textField:'text',
        data:data,
        filter: function(q, row){
			var opts = $(this).combobox('options');
			return ("-"+row[opts.textField]).toUpperCase().indexOf("-"+q.toUpperCase()) >-1;
		}
    };
    if(id=='PrescTypeComb'){
	    $.extend(ComboObj,{
		    onSelect:function(){
			    PrescTypeChange();
			}
		})
	}else if(id=='InstrComb'){
		$.extend(ComboObj,{
		    onSelect:function(){
			    $('#DoseQtyComb').combobox('select',"")
			    $('#DoseQtyComb').combobox('reload');
			    SetCMDoseQty($('#DoseQtyComb').combobox('getValue'));
			}
		})
	}
    $("#"+id).combobox(ComboObj);
}
function PrescTypeChange()
{
	//ѡ�񴦷����ͺ��ʼ���÷���������Ϣ
	 var PrescTypeInfo=$("#PrescTypeComb").combobox('getValue');
	 var CNInfoArr="",FreqRowid="",InstrRowid="",DurRowid="",DefaultQtyID=""
	 if(PrescTypeInfo!=''){
		 CNInfoArr=PrescTypeInfo.split("#");
		 FreqRowid=CNInfoArr[1].split("!")[0];
		 InstrRowid=CNInfoArr[2].split("!")[0];
		 DurRowid=CNInfoArr[3].split("!")[0];
		 DefaultQtyID=CNInfoArr[4].split("!")[0];
		 $('#DoseQtyComb').combobox('select',"");
	 }
	 SetCMInfo(DurRowid,FreqRowid,InstrRowid,DefaultQtyID);
}
function SetCMInfo(DurRowid,FreqRowid,InstrRowid,QtyID)
{
	$('#DurationComb').combobox('select',DurRowid);
	$('#FreqComb').combobox('select',FreqRowid);
	$('#InstrComb').combobox('select',InstrRowid);
	setTimeout(function(){SetCMDoseQty(QtyID);},1000);
}
function SetCMDoseQty(QtyID)
{
	$('#DoseQtyComb').combobox('setValue','');
	var DoseQtyArr=$('#DoseQtyComb').combobox('getData');
	for(var i=0;i<DoseQtyArr.length;i++){
		if(DoseQtyArr[i].Code==QtyID){
			$('#DoseQtyComb').combobox('setValue',QtyID);
			break;
		}
	}
}
function CNSaveClickHandler()
{
	var SelectedRow=UDHCFavOrderSetsEditDataGrid.datagrid('getSelected');
	if(!SelectedRow){
		$.messager.alert('��ʾ','δѡ��ҽ����!');
		return false;
	}
	var OSRowid=SelectedRow.ARCOSRowid
	var PrescTypeCode=getCombValue("PrescTypeComb","id") //$("#PrescTypeComb").combobox('getValue').split("#")[0];
	if (PrescTypeCode!=""){
		PrescTypeCode=PrescTypeCode.split("#")[0];
	}else{
		$.messager.alert('��ʾ','��ѡ�񴦷�����!');
		return false;
	}
	var DuratId=getCombValue("DurationComb","id") //$('#DurationComb').combobox('getValue');
	var FreqId=getCombValue("FreqComb","id") //$('#FreqComb').combobox('getValue');
	var InstrId=getCombValue("InstrComb","id") //$('#InstrComb').combobox('getValue');
	var DoseQtyId=getCombValue("DoseQtyComb","Code") //$('#DoseQtyComb').combobox('getValue');
	var Notes=$('#CNNote').val();
	$.cm({
		ClassName:"DHCDoc.DHCDocConfig.OrdSets",
		MethodName:"SaveOSCNInfo",
		OSRowid:OSRowid, PrescTypeCode:PrescTypeCode, DoseQtyId:DoseQtyId, DuratId:DuratId, FreqId:FreqId, InstrId:InstrId, Notes:Notes,
		dataType:"text"
	},function(ret){
		if(ret=='0'){
			$.messager.popover({msg: '������ҩҽ������Ϣ�ɹ�!',type:'success'});
			var rowIndex=UDHCFavOrderSetsEditDataGrid.datagrid('getRowIndex',SelectedRow);
	        UDHCFavOrderSetsEditDataGrid.datagrid('updateRow',{
				index: rowIndex,
				row: {PrescTypeCode:PrescTypeCode,DuratId:DuratId,DosageId:DoseQtyId,FreqId:FreqId,InstrId:InstrId,Notes:Notes}
			});
		}else{
			$.messager.alert('��ʾ','������ҩҽ������Ϣʧ��:'+ret);
		}
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
function InitPrescNotes(){
	$("#CNNote").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
			{field:'Desc',title:'����',width:350,sortable:true},
			{field:'Code',hidden:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:370,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.PilotProject.DHCDocPilotProject',QueryName: 'FindDefineData',MDesc:"ҽ��¼���ֵ�",DDesc:"��ҩ¼�뱸ע"},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
			param = $.extend(param,{Alias:desc});
	    },onSelect:function(ind,item){
		    $("#CNNote").val(item.Desc);
		}
    });
}
function getValue(id){
	var className=$("#"+id).attr("class")
	if(typeof className =="undefined"){
		return $("#"+id).val()
	}
	if(className.indexOf("hisui-lookup")>=0){
		var txt=$("#"+id).lookup("getText")
		//����Ŵ��ı����ֵΪ��,�򷵻ؿ�ֵ
		if(txt!=""){ 
			var val=$("#"+id).val()
		}else{
			var val=""
			$("#"+id+"Id").val("")
		}
		return val
	}else if(className.indexOf("hisui-combobox")>=0){
		var val=$("#"+id).combobox("getValue")
		if(typeof val =="undefined") val=""
		return val
	}else if(className.indexOf("hisui-datebox")>=0){
		return $("#"+id).datebox("getValue")
	}else{
		return $("#"+id).val()
	}
	return ""
}
//ҽ��������������Ŀ
function OtherARCAlias()
{
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections')
	if ((rowdata)&&(rowdata.length!=0)){
		ARCOSRowid=rowdata[0].ARCOSRowid;
		var src="dhcdoc.arcosoteralias.hui.csp?ARCOSRowid="+ARCOSRowid;   
		if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
		var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
		createModalDialog("ARCOSEdit","ҽ���ױ���ά��", 500, 500,"icon-w-inv","",$code,"")
	}else{
		$.messager.alert('��ʾ','��ѡ��һ��ҽ����!');
	}
}
function AuthorizeSetWinClick(){
	if (SelectRow1=="-1"){
		$.messager.alert('��ʾ','��ѡ����Ҫ��Ȩ��ҽ����!');
		return;
	}
	$("#List_OrderDept").empty();
	//��Ȩ�����б�
	LoadOrderDept("List_OrderDept");
	$("#FindDept").searchbox("setValue","");
	if ($("#RecSetWin").hasClass('window-body')){
		$('#RecSetWin').window('open');
	}else{
		ShowHolidaysRecSetWin();
	}
	$("#FindDept").next('span').find('input').focus();
}
function LoadOrderDept(param1){
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections');
	var ARCOSRowid=rowdata[0]["ARCOSRowid"];
	$.cm({
		ClassName:"web.DHCARCOrdSetsAuthorize",
		QueryName:"FindDep",
		ARCOSRowId:ARCOSRowid,
		rows:"99999",
	},function(objScope){
	   var vlist = ""; 
	   var selectlist="";
	   jQuery.each(objScope.rows, function(i, n) { 
		    selectlist=selectlist+"^"+n.selected
            vlist += "<option value=" + n.CTLOCRowID + " alias=" + n.alias + ">" + n.CTLOCDesc + "</option>"; 
       });
       $("#"+param1+"").append(vlist); 
	   for (var j=1;j<=selectlist.split("^").length;j++){
			if(selectlist.split("^")[j]=="true"){
				$("#"+param1+"").get(0).options[j-1].selected = true;
			}
		}
	});
}
function ShowHolidaysRecSetWin(){
	$('#AuthorizeSetWin').window({
		title: 'ҽ������Ȩ',
		zIndex:9999,
		iconCls:'icon-w-edit',
		inline:false,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closable:true
	});
}
function BSaveARCLocAuthorize(){
	var rowdata=$('#UDHCFavOrderSetsEdit').datagrid('getSelections');
	var ARCOSRowid=rowdata[0]["ARCOSRowid"];
	var LocStr="";
	var obj=$("#List_OrderDept").find("option:selected");
	for (var i=0;i<obj.length;i++){
		var LocID=obj[i].value;
		if (LocStr=="") LocStr=LocID;
		else LocStr=LocStr+"^"+LocID;
	}
	var rtn=$.cm({
		ClassName:"web.DHCARCOrdSetsAuthorize",
		MethodName:"SaveARCLocAuthorize",
		ARCOSRowId:ARCOSRowid,
		LocStr:LocStr,
		dataType:"text"
	},false);
	$("#AuthorizeSetWin").window('close');
}
function FindDeptChange(value){
	value=value.toUpperCase();
	var matchIndexArr=new Array();
	var _$selOptions=$("#List_OrderDept option");
	var Obj=document.getElementById('List_OrderDept');
	for (var i=0;i<Obj.length;i++){
		$(_$selOptions[i]).show();
		var DepDesc=Obj[i].text;
		var DepArr=DepDesc.split("-");
		var selText=DepArr[0].toUpperCase();
		var selCode="";
		if (DepArr[1]) {
			selCode=DepArr[1].toUpperCase();
		}
		if ((selText.indexOf(value)>=0)||(selCode.indexOf(value)>=0)){
			matchIndexArr.push(i);
		}else{
			$(_$selOptions[i]).hide();
		}
	}
	if ((matchIndexArr.length>=1)&&(value!="")){
		Obj.selectedIndex=matchIndexArr[0];
	}
}

function CloseWindow(ARCOSRowidGet,ARCOSSubCatID,SaveType){
	if(window){
	  var obj =window.dialogArguments
	  if(obj){
		  window.returnValue=ARCOSRowidGet;
		  window.close();
	  } 
      if (websys_showModal('options')) {
	      websys_showModal("hide");
	      if (websys_showModal('options').SaveItemToARCOS) {
		      websys_showModal('options').SaveItemToARCOS(ARCOSRowidGet);
		  }
		  if (websys_showModal('options').CallBackFunc) {
		      websys_showModal('options').CallBackFunc(ARCOSRowidGet);
		  }
	      websys_showModal("close");
	  }
	}
	if((SaveType=="A")&&(ARCOSRowidGet)&&(!websys_showModal('options'))){
		$.messager.confirm("ȷ�϶Ի���", "�Ƿ�ҽ���ס�"+$("#Desc").val()+"�����浽ҽ��ģ�壿", function (r) {
			if (r) {
				var Type="��ҩ";
			    var index = $('#UDHCFavOrderSetsEdit').datagrid('getRowIndex', ARCOSRowid);
			    var rows = $('#UDHCFavOrderSetsEdit').datagrid('getRows');
				if(CNMedItemCatStr.indexOf("^"+ARCOSSubCatID+"^")>-1){	//���в�ҩҽ����
					Type="��ҩ";
				}
			    OpenOrdTemplateWin(Type,ARCOSRowidGet);
			}
		});
	 }
}
function OpenOrdTemplateWin(Type,ARCOSRowid)
{
	websys_showModal({
		url:"doc.arcossavetotemplate.hui.csp?Type="+Type,
		title:'���浽ҽ��ģ��',
		paraObj:{name:ARCOSRowid},
		width:'500px',height:'420px'
	})
}