//===========================================================================================
// ���ߣ�      bianshuai
// ��д����:   2019-06-20
// ����:	   ֪ʶ����ʾҳ��
//===========================================================================================

var editRow = -1;  /// �༭������
var editid = "";   /// �༭grid id
var checkFlag = 1; /// ������黹��ģ�屣��
var PageCompObj = [    	/// ҳ��Ԫ������
	{El:"PatName", Type:"input"},
	{El:"PatSex", Type:"combobox"},
	{El:"PatBDay", Type:"datebox"},
	{El:"Height", Type:"input"},
	{El:"Weight", Type:"input"},
	//{El:"Liver", Type:"combobox"},
	{El:"Renal", Type:"combobox"},
	{El:"SpecGrps", Type:"combobox"},
	{El:"PreFlag", Type:"input"},
	{El:"itemAyg", Type:"datagrid"},
	{El:"itemDis", Type:"datagrid"},
	{El:"itemLab", Type:"datagrid"},
	{El:"labItm", Type:"datagrid"},
	{El:"itemOper", Type:"datagrid"},
	{El:"itemOrder", Type:"datagrid"},
	{El:"ProFess", Type:"combobox"},
	{El:"PatType", Type:"combobox"},	// �������
	{El:"ItemSym", Type:"datagrid"}
];

var LabArray=[{"value":"Lab","text":"������"},{"value":"LabItm","text":"������"}]
var SkinArray=[{"value":"N","text":"����"},{"value":"Y","text":"����"}]
var PatTypeArr=[{"value":"����","text":"���ﻼ��"},{"value":"����","text":"���ﻼ��"},{"value":"סԺ","text":"סԺ����"}]
var DisFlagArr = [{"value":"dis","text":"���"},{"value":"sym","text":"֢״"}]
var PriorityArr = [{"value":"����ҽ��","text":"����ҽ��"},{"value":"PRN","text":"PRN"},{"value":"��ʱҽ��","text":"��ʱҽ��"},{"value":"����ҽ��","text":"����ҽ��"},{"value":"ȡҩҽ��","text":"ȡҩҽ��"},{"value":"��Ժ��ҩ","text":"��Ժ��ҩ"},{"value":"�Ա�ҩ����","text":"�Ա�ҩ����"},{"value":"�Ա�ҩ����","text":"�Ա�ҩ����"},{"value":"��������","text":"��������"},{"value":"��ʱ����","text":"��ʱ����"}]
/// ҳ���ʼ������
function initPageDefault(){
	
	//_openShowAuditPopProcess({"userType":"Doc"});
	//setRatio();
	
	InitPageComp(); 	  /// ��ʼ������ؼ�����
}

function setRatio(){
    
	    var defaultRatio = 1;//Ĭ�����ű�
	    var ratio=0;
	    var screen=window.screen;
	    var ua=navigator.userAgent.toLowerCase();
	 
	    if(window.devicePixelRatio !== undefined)
	    {
	        ratio=window.devicePixelRatio;    
	    }
	    else if(~ua.indexOf('msie'))
	    {
	        if(screen.deviceXDPI && screen.logicalXDPI)
	        {
	            ratio=screen.deviceXDPI/screen.logicalXDPI;        
	        }
	    
	    }
	    else if(window.outerWidth !== undefined && window.innerWidth !== undefined)
	    {
	        ratio=window.outerWidth/window.innerWidth;
	    }
	 
	    if(ratio > 1)
	    {
	        
	        var setZoom = defaultRatio/window.devicePixelRatio; //Ĭ��zoom
	        document.body.style.zoom = setZoom.toFixed(6);
	    }
	    // return ratio;
}
	
/// ��ʼ������ؼ�����
function InitPageComp(){
	
	/// ѡ��ģ��
	/*var option = {
		blurValidValue:true,
		hasDownArrow:true,
        onSelect:function(option){
			/// ѡ��ģ��
			LoadTempPanel(option.value, 1);
			$("#TempLabel").show();  /// ģ�����label
			$("#TempTitle").show();  /// ģ�����input
		 	var ThisTitle=option.text.split("<img")[0];
			$("#TempTitle").val(ThisTitle);
			//$HUI.combobox("#TakTemp").setValue(ThisTitle);
	    },
	    onShowPanel: function () { //���ݼ�������¼�
			$("#TakTemp").combobox('reload',$URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakTemp");
        }
	};
	var url = ""; //$URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakTemp";
	new ListCombobox("TakTemp", url, '', option).init();
	*/
	$('#TakTemp').combotree({
    	url:LINK_CSP+'?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakTemp',
    	lines:true,
		animate:true,
		 onSelect:function(option){
			/// ѡ��ģ��
			LoadTempPanel(option.value, 1);
			$("#TempLabel").show();  /// ģ�����label
			$("#TempTitle").show();  /// ģ�����input
		 	var ThisTitle=option.text.split("<img")[0];
			$("#TempTitle").val(ThisTitle);
	    },
	})
	
	/// �Ա�
	var option = {
		blurValidValue:true,
        onSelect:function(option){
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakDataByType&type=sex";
	new ListCombobox("PatSex", url, '', option).init();
	
	/// ����״̬
	var option = {
		blurValidValue:true,
        onSelect:function(option){

	    }
	};
	//var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakLiver";
	//new ListCombobox("Liver", url, '', option).init();
	
	/// ����״̬
	var option = {
		blurValidValue:true,
        onSelect:function(option){

	    }
	};
	//var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakRenal";
	//new ListCombobox("Renal", url, '', option).init();
		
	/// ������Ⱥ
	var option = {
		blurValidValue:true,
		multiple:true,
        onSelect:function(option){		
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakSpecGrps";
	new ListCombobox("SpecGrps", url, '', option).init();
	
	/// ְҵ
	var option = {
		blurValidValue:true,
		multiple:false,
        onSelect:function(option){		
	    }
	};
	var url = $URL+"?ClassName=web.DHCCKBBaseDemo&MethodName=JsTakDataByType&type=profess";
	new ListCombobox("ProFess", url, '', option).init();
	
	
	/// �������
	var option = {
		data:PatTypeArr,
		blurValidValue:true,
		multiple:false,
        onSelect:function(option){		
	    }
	};
	var url = ""
	new ListCombobox("PatType", url, '', option).init();
}

var itemObj = {'itemAyg':0, 'itemDis':0, 'itemOrder':0, 'itemLab':0, 'itemOper':0};

/// �����
function add(id){
	
	endEditRow();  /// �رյ�ǰ�༭��
	
	var WarnID = TakUniqueSign(id); /// ��ȡÿ�е�Ψһ��ʶ
    var rowObj = "";
    if (id == "itemLab"){
		rowObj = {Warn:WarnID, Item:'', Val:'', Uom:'', id:id};
	}else if (id == "itemOrder"){
		rowObj = {Warn:WarnID, SeqNo:'',PhDesc:'', PForm:'', DosQty:'', DosUom:'', Instr:'', Freq:'', Duration:'',  LinkSeqNo:'',id:id,OrdDate:"",FirstMark:"",OrdEndDate:""};
		//rowObj = {Warn:WarnID, PhDesc:'', PForm:'', DosQty:'', DosUom:'', Instr:'', Freq:'', Duration:'', id:id};
	}else if (id == "itemDis"){
		rowObj = {Warn:WarnID, Type:'���',item:"",id:id};
	}else {
		rowObj = {Warn:WarnID, Item:'', id:id};
	}
	
	
	$("#"+id).datagrid('appendRow',rowObj);

	
	if (id == "itemOrder"){		// ���
		var index = $("#"+id).datagrid("getRowIndex",rowObj) +1;	
		// �õ�columns����
		var columns =  $("#"+id).datagrid("options").columns;
		var rows = $("#"+id).datagrid("getRows"); 
		rows[index-1][columns[0][1].field]=index+"";
		
		// ˢ�¸���, ֻ��ˢ���˲���Ч��
		$("#"+id).datagrid('refreshRow', index-1);
	}
	
}

/// ���
function clr(id){
	$("#"+id).datagrid('loadData',{total:0,rows:[]});
}



/// ����
function takCellUrl(value, rowData, rowIndex){

	var html = '<a href="#" onclick="del(\''+ rowData.id +'\',\''+ value +'\',\''+ rowIndex +'\')"><img src="../scripts/dhcnewpro/dhcckb/images/cancel.png" border=0/></a>';	
	return html;
}

/// ɾ��
function del(id, value, rowIndex){
	
	var rowsData = $("#"+id).datagrid('getRows');
	for (var index=rowsData.length-1; index >= 0; index--){
		if (rowsData[index].Warn == value){
			$("#"+id).datagrid('deleteRow',index);
		}
	}
}

/// ҽ��ɾ��
function delord(id){
	
    var rowData = $("#"+id).datagrid('getSelected');
    var index = $("#"+id).datagrid('getRowIndex', rowData);
	$("#"+id).datagrid('deleteRow',index);

}

/// ˫�����¼�
function onClickRow(rowIndex, rowData) {
	
    endEditRow();  /// �رյ�ǰ�༭��
    
    $("#"+ rowData.id).datagrid('beginEdit', rowIndex); 
    
    editid = rowData.id;   /// ��ǰ�༭datagrid
    editRow = rowIndex;    /// ��ǰ�༭��
}

/// �رյ�ǰ�༭��
function endEditRow(){
	
	if ((editRow != -1)||(editRow == 0)) { 
        $("#"+editid).datagrid('endEdit', editRow); 
    }
    $("#"+ editid).datagrid("unselectRow", editRow);
    editid = "";     /// ��ǰ�༭datagrid
    editRow = -1;    /// ��ǰ�༭��
}

/// ����ģ��
function InsTemp(){
	
	endEditRow();  /// �رյ�ǰ�༭��
	checkFlag=0;
	var TempObj = TakTempObj();         /// ȡ������
	if (!isIntegrity(TempObj)) return;  /// ����������Ч��
	
	if ($("#TempTitle").val() == ""){
		$("#TempLabel").show();  /// ģ�����label
		$("#TempTitle").show();  /// ģ�����input
		$.messager.alert("��ʾ:","����дģ����⣡","info");
		return;
	}
	
	//var ID = $HUI.combobox("#TakTemp").getValue(); /// ��������ID
	//��ȡ��ǰcombotree��tree����
	var tree = $('#TakTemp').combotree('tree');
	//��ȡ��ǰѡ�еĽڵ����
	var data = tree.tree('getSelected');
	//��ȡidֵ
	if(data==null)
	{
		var ID="";
	}else
	{
		var ID=data.value;
	}
	if (!$.isEmptyObject(TempObj)){
		var TitleTag=$("#TempTitle").val();
		var standardTag=$("#standardRadio:checked").val()=="on"?true:false;
		if(standardTag)
		{
			TitleTag=TitleTag+"[standard]";
		}
		
		InvInsTemp(ID, TitleTag , TempObj);
	}
}

/// ֪ʶ��������
function TakTempObj(){

	var TempObj = {};
	TempObj.PatName = $("#PatName").val();  /// ��������
	TempObj.PatSex = $HUI.combobox("#PatSex").getText();    /// �����Ա�
	TempObj.PatBDay = $HUI.combobox("#PatBDay").getValue();  /// ��������
	TempObj.Height = $("#Height").val();    /// ���
	TempObj.Weight = $("#Weight").val();    /// ����
	//TempObj.Liver = $HUI.combobox("#Liver").getValue();  /// ����״̬
	//TempObj.Renal = $HUI.combobox("#Renal").getValue();  /// ����״̬
	TempObj.SpecGrps = $HUI.combobox("#SpecGrps").getText().split(",");  /// ������Ⱥ getValue()
	TempObj.ProFess = $HUI.combobox("#ProFess").getText();  /// ְҵ
	TempObj.PreFlag = $("#PreFlag").val();         /// �Ƿ���
	TempObj.itemAyg = TrGridToArr("itemAyg");      /// ����Դ
	var ItemDis = TrGridToArr("itemDis");      /// �������
	var SymArr = [];
	var DisArr = [];
	for (i=0;i<ItemDis.length;i++){
		var ItemObj=ItemDis[i];
		if (ItemObj.Type=="sym"){
			SymArr.push(ItemObj)
		}else{
			DisArr.push(ItemObj)
		}
	}
	TempObj.itemDis = DisArr;
	TempObj.ItemSym = SymArr;
	
	//TempObj.itemLab = TrGridToArr("itemLab");      /// ����
	var ItemLab=TrGridToArr("itemLab"); 
	var LabArr=[];
	var LabItmArr=[];
	for (i=0;i<ItemLab.length;i++){
		var labObj=ItemLab[i];
		if (labObj.Type=="Lab"){
			LabArr.push(labObj)
		}if(labObj.Type=="LabItm"){
			LabItmArr.push(labObj)
		}
	}
	TempObj.itemLab = LabArr;
	TempObj.labItm=LabItmArr;	
	TempObj.itemOper = TrGridToArr("itemOper");    /// ����
	TempObj.itemOrder = TrGridToArr("itemOrder");  /// ҽ���б�
	var SkinArr=GetSkinList();	// ��ҩƷ�б���Ƥ�Խ��Ϊ���Ե�ҩƷ�����뵽����Դ��
	TempObj.itemAyg.push.apply(TempObj.itemAyg,SkinArr)
	TempObj.PatLoc=LgCtLocDesc	// ����
	TempObj.DocUser=LgUserDesc	// ҽ��
	TempObj.Group=LgGroupDesc	// ��ȫ��
	TempObj.Hospital=LgHospDesc	// ҽԺ
	TempObj.Profess=LgProfessDesc	// ְ��
	TempObj.ItemHisOrder = TrGridToHisOrderArr("itemOrder")	// qnp 2020/12/17 ģ����ʷҽ���б�
	
	TempObj.PatType = $HUI.combobox("#PatType").getValue();  /// ������� qnp 2022/05/10
	return TempObj;
}

/// ���ñ���ģ��
function InvInsTemp(ID, TempTitle, jsTempObj){

	runClassMethod("web.DHCCKBBaseDemo","InsTestCaseTemp",{"ID":ID, "TempTitle":TempTitle, "jsTempObj":JSON.stringify(jsTempObj)},function(ID){
		if (ID < 0){
			$.messager.alert("��ʾ:","��׼ģ�岻�����޸ģ�");
		}else{
			$.messager.alert("��ʾ:","����ɹ���","info");
			//$("#TempLabel").hide().val(""); /// ģ�����input
			//$("#TempTitle").hide();			/// ģ�����label
			$('#TakTemp').combotree('reload');
			LoadTempPanel(ID, ""); /// ����ģ��
		}
	},'',false)
}

/// ��ȡģ������
function LoadKbTemp(ID){
	
	var baseObject = {};
	runClassMethod("web.DHCCKBBaseDemo","JsGetKbTemp",{"ID":ID},function(jsonObject){
		baseObject = jsonObject
	},'json',false)
	return baseObject;
}

/// ѡ��ģ��
function LoadTempPanel(ID, isFlag){
	  
	ClrPanel(isFlag);  /// ���
	var TempObj = LoadKbTemp(ID);  /// ��ȡģ������
	if ($.isEmptyObject(TempObj)) {
		$.messager.alert("��ʾ:","��ȡ����ģ������Ϊ�գ�","warning");
		return;
	}
	
	var ItemLabLen=0
	var ItemDisLen=0
	var ItmLabArr=[]
	var ItmDisArr=[]
	for(var n in PageCompObj){
		
		/// �ı���ֵ
		if (PageCompObj[n].Type == "input"){
			$("#" + PageCompObj[n].El).val(TempObj[PageCompObj[n].El]);
		}
		
		/// ������ֵ
		if (PageCompObj[n].Type == "combobox"){
			$HUI.combobox("#" + PageCompObj[n].El).setValue(TempObj[PageCompObj[n].El]);
		}
		
		/// ʱ���ֵ
		if (PageCompObj[n].Type == "datebox"){
			$HUI.datebox("#" + PageCompObj[n].El).setValue(TempObj[PageCompObj[n].El]);
		}
				
		/// �б�ֵ
		if (PageCompObj[n].Type == "datagrid"){
			if ((PageCompObj[n].El == "labItm")||(PageCompObj[n].El == "itemLab")) {	// ��������������飬���ǽ�����ֻ��һ��λ����ʾ qunianpeng 2020/4/4
				if(TempObj[PageCompObj[n].El]==undefined){continue;}
				ItemLabLen += TempObj[PageCompObj[n].El].length;
				ItmLabArr.push.apply(ItmLabArr,TempObj[PageCompObj[n].El])	// ����ƴ�� 
				
			}else if ((PageCompObj[n].El == "ItemSym")||(PageCompObj[n].El == "itemDis")) {	
				if(TempObj[PageCompObj[n].El]==undefined){continue;}
				ItemDisLen += TempObj[PageCompObj[n].El].length;
				ItmDisArr.push.apply(ItmDisArr,TempObj[PageCompObj[n].El])	// ����ƴ�� 
			}
			else
			{
				if(TempObj[PageCompObj[n].El]==[]) continue;
				$("#" + PageCompObj[n].El).datagrid('loadData',{total:TempObj[PageCompObj[n].El].length,rows:TempObj[PageCompObj[n].El]});
			}
		}
	}
	$("#itemDis").datagrid('loadData',{total:ItemDisLen,rows:ItmDisArr});
	$("#itemLab").datagrid('loadData',{total:ItemLabLen,rows:ItmLabArr});	
	
}
/// datagrid�б�
function TrGridToArr(id){
	var nowdate = toDDMMMYYYY();
	var TmpArr = [];
	var rowsData = $("#"+id).datagrid('getRows');
	for (var m in rowsData){
		if (id == "itemOrder"){	
			//var tmpData=rowsData.concat();			// ��������	
			var tmpData=JSON.parse(JSON.stringify(rowsData));	// ���
			if(checkFlag==1){
				tmpData[m].LinkSeqNo=(tmpData[m].LinkSeqNo=="")?tmpData[m].SeqNo:tmpData[m].LinkSeqNo+"."+tmpData[m].SeqNo;
				tmpData[m].DosQty = ChangeDose(tmpData[m].DosUom, tmpData[m].DosQty);
				tmpData[m].DosUom = ChangeUnit(tmpData[m].DosUom);
				if ((tmpData[m].OrdEndDate !="")&(tmpData[m].OrdEndDate != undefined)){	// ҽ��ֹͣ���ڲ�Ϊ��,����Ϊ����ʷҽ��
					continue;
				}
				if ((tmpData[m].OrdDate !="")&(tmpData[m].OrdDate<nowdate)){	// ҽ������С�ڵ���,����Ϊ����ʷҽ��
					continue;
				}				
			}
			
			TmpArr.push(tmpData[m]);			
		}else{
			TmpArr.push(rowsData[m]);	
		}		
	}
	return TmpArr;
}

/// datagrid�б�
function TrGridToHisOrderArr(id){
	var nowdate = toDDMMMYYYY();
	var TmpArr = [];
	var rowsData = $("#"+id).datagrid('getRows');
	for (var m in rowsData){
		if (id == "itemOrder"){	
			//var tmpData=rowsData.concat();			// ��������	
			var tmpData=JSON.parse(JSON.stringify(rowsData));	// ���
			if(checkFlag==1){
				tmpData[m].LinkSeqNo=(tmpData[m].LinkSeqNo=="")?tmpData[m].SeqNo:tmpData[m].LinkSeqNo+"."+tmpData[m].SeqNo;
			}
			
			if ((tmpData[m].OrdDate =="")&&((tmpData[m].OrdEndDate=="")||(tmpData[m].OrdEndDate==undefined))){	// ҽ��ֹͣ���ڲ�Ϊ��,����Ϊ����ʷҽ��
				continue;
			}			
		
			if ((tmpData[m].OrdDate !="")&&(tmpData[m].OrdDate>=nowdate)){	// ҽ������С�ڵ���,����Ϊ����ʷҽ��
				continue;
			}
			TmpArr.push(tmpData[m]);			
		}else{
			TmpArr.push(rowsData[m]);	
		}		
	}
	return TmpArr;
}


/// ֪ʶ��ص�����
function SetItemWarnFlag(itemWarnObj){
	
	var a = 11
	//alert("��ɻص�"+itemWarnObj.passFlag)
	
}

/// ����������Ч��
function isIntegrity(jsTakTempObj){
	
	if (jsTakTempObj.PatName == ""){
		$.messager.alert("��ʾ:","��������Ϊ��","warning");
		return false;	
	}
	if (jsTakTempObj.PatSex == ""){
		$.messager.alert("��ʾ:","�Ա���Ϊ��","warning");
		return false;	
	}
	if (jsTakTempObj.PatBDay == ""){
		$.messager.alert("��ʾ:","�������ڲ���Ϊ��","warning");
		return false;	
	}
	if (jsTakTempObj.itemOrder.length == 0){
		$.messager.alert("��ʾ:","ҩƷ�б���Ϊ��","warning");
		return false;	
	}
		return true;
	
}

/// ���
function TakCheck(){
	
	endEditRow();  /// �رյ�ǰ�༭��
	checkFlag=1;
	var jsTakTempObj = TakTempObj();   		 /// ȡ������
	if (!isIntegrity(jsTakTempObj)) return;  /// ����������Ч��
	//$.messager.alert("��ʾ:","���ͨ��","info",function(){
	jsTakTempObj.Action="CheckRule";;		/// Ӧ�ù���
	//var InreViewObj = new InreView({});      /// ��ʼ��֪ʶ��
	var InreViewObj = new PDSS({});          /// ��ʼ��֪ʶ��
	
	var PdssData={
		"lmID":"",	        //  �����־ID
		"PatName":"����",	//  ����
		"SexProp":"��",		// �Ա�
		"AgeProp":"1993-02-10",	// ��������
		"Height":"170",		// ���(����ֵ)
		"Weight":"51",		// ����(kg) 
		"BillType":"ҽ��",	// �ѱ� (ҽ��,�Է�)
		"BloodPress":"",	// Ѫѹ
		"SpecGrps":["�����ܲ�ȫ","�и�"],	//������Ⱥ
		"ProfessProp":"�˶�Ա",	// ְҵ
		"PatType":"����",	// �������(����,סԺ,����)
		"PreFlag":"��",		// �Ƿ���
		"itemAyg":[			// ������¼
			{
				"Warn":"96",	// ���
				"Item":"",
				"id":"itemAyg",	// ��ʶ
				"item":"��ù��"	// ������Ŀ
			}
		],
		"itemDis":[				// ����
			{
				"Warn":"14",	// ���
				"Item":"",
				"id":"itemDis",	// ��ʶ
				"item":"����"	// ����
			},
			{
				"Warn":"455",
				"Item":"",
				"id":"itemDis",
				"item":"�ж���"
			}
		],
		"itemLab":[				// ����
			{
				"Warn":"35",	//���
				"Item":"",		//	
				"Val":"10",		// ������ֵ
				"Unit":"mg",		// ������ֵ��λ
				"id":"itemLab",	// ��ʶ
				"item":"��ϸ��"	// ������Ŀ
			}
		],
		"itemOper":[				// ����
			{
				"Warn":"10",		// ���
				"Item":"",		
				"id":"itemOper",	// ��ʶ
				"item":"­���к���"	// ��������
			}
		],
		"itemOrder":[		// ҩƷ
			{
				"Warn":"34",				// ���
				"PhDesc":"��˾ƥ�ֳ���Ƭ",	// ҩƷ����
				"FormProp":"Ƭ��",				// ����
				"OnceDose":"200",				// ���μ���
				"Unit":"mg",				// ���μ�����λ
				"DrugPreMet":"�ڷ�",				// �÷�
				"DrugFreq":"tid",				// Ƶ��
				"Treatment":"1��",				// �Ƴ�
				"id":"itemOrder",			// ��ʶ
				"SeqNo":"1",				// ҽ�����
				"LinkSeqNo":"1",			// �������(1, 1.1, 1.2)
				"OrdDate":"2020-03-06",		// ҽ������
				"IsFirstUseProp":"�״�",			// �Ƿ��״�(�״�/���״�)
				"DurgSpeedProp":""			// ��ҩ�ٶ�
			},
			{
				"Warn":"743",
				"SeqNo":"2",
				"PhDesc":"��������������Һ",
				"FormProp":"���ۼ�",
				"OnceDose":"2",
				"Unit":"��",
				"DrugPreMet":"����",
				"DrugFreq":"ÿ��4��",
				"Treatment":"2��",
				"LinkSeqNo":"2.2",
				"id":"itemOrder",
				"OrdDate":"2020-03-06",
				"IsFirstUseProp":"�״�",
				"DurgSpeedProp":""			// ��ҩ�ٶ�
			}	
		]
	}

	// PdssData
	//InreViewObj.refresh(PdssData, SetItemWarnFlag, 1); /// ���
	console.log(jsTakTempObj)
	InreViewObj.refresh(jsTakTempObj, SetItemWarnFlag, 1); /// ���
	//	}); 

}

/// ���
function ClrPanel(hideFlag){
	
//	/// ��ѡ��
//	$('input[type="checkbox"]').attr("checked",false);
//	
//	/// ��ѡ
//	$('input[type="radio"]').attr("checked",false);
	
	/// �ı���
	$('input:text[id]').not('.combobox-f').not('.datebox-f').each(function(){
		$("#"+ this.id).val("");
	})

	/// Combobox
	$('input.combobox-f').each(function(){
		if ((hideFlag)&(this.id == "TakTemp")) return;
		$("#"+ this.id).combobox("setValue","");
	})
	
	/// ����
	$('input.datebox-f').each(function(){
		$("#"+ this.id).datebox("setValue","");
	})
	
	/// ����б�
	var itemArr = ['itemAyg', 'itemDis', 'itemOrder', 'itemLab', 'itemOper'];
	for(var i=0; i<itemArr.length; i++){
		$("#" + itemArr[i]).datagrid('loadData',{total:0,rows:[]});
	}
}

/// �����ָʾ��
function takCellWarn(value, rowData, rowIndex){
	var html = '<div class="warn-light"><img id="WL'+ value +'" src="" border=0/></div>';	
	return html;
}

/// ��ȡ��̨Ψһ��ʶ
function TakUniqueSign(id){
	
	var unIdent = "";
	runClassMethod("web.DHCCKBBaseDemo","TakUniqueIdent",{"ID":id},function(jsonString){
		unIdent = jsonString;
	},'',false)
	return unIdent;
}

/// ҳ��ȫ���������֮�����(EasyUI������֮��)
function onload_handler() {
	
}

///����ȡֵ����
function fillValue(rowIndex, rowData){
	$('#itemOrder').datagrid('getRows')[editRow]['PhDesc']=rowData.CDDesc
}

/// ��ȡҩƷ�б�����Ƥ�Խ��Ϊ���Ե�ҩƷ,���뵽����Դ��
function GetSkinList(){
	
	var skinArr=[];
	var rowsData = $("#itemOrder").datagrid('getRows');
	for (var m in rowsData){
		if (rowsData[m].Skin == "Y"){		// ����
			if (rowsData[m].PhDesc != ""){
				var warnID = TakUniqueSign("itemAyg"); /// ��ȡÿ�е�Ψһ��ʶ
				var skinObj={"Warn":warnID,"Item":"","id":"itemAyg","item":rowsData[m].PhDesc}
				skinArr.push(skinObj)
			}					
		}		
	}
	
	return skinArr;
	
}
///ģ�����
function DelTemp(){
	//��ȡ��ǰcombotree��tree����
	var tree = $('#TakTemp').combotree('tree');
	//��ȡ��ǰѡ�еĽڵ����
	var data = tree.tree('getSelected');
	//��ȡidֵ
	var TempID=data.value;
	 //var TempID = $("#TakTemp").combotree("getValue"); //$HUI.combotree("#TakTemp").getValue();
	 if(TempID == ""){
		  $.messager.alert('��ʾ',"����ѡ��Ҫɾ����ģ��");
		  return;
		}
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod("web.DHCCKBBaseDemo","DelTemp",{"ID":TempID},function(ret){
							if(ret==0){
								ClrPanel();
								$('#TakTemp').combotree('reload');
							}
				},'',false)
			}
		});
}

/// ��顾������
function OpenPdss(){
	
	 var _Width = 800;
     var _Height = 400;
	 var _Top = (window.screen.availHeight-30-_Height)/2; 
     var _Left = (window.screen.availWidth-10-_Width)/2;
	 window.open ("dhcckb.pdssservice.csp?logid=6695734", "��ȫ��ҩ�������", "height="+ _Height +", width="+ _Width +", top="+ _Top +", left="+ _Left +", toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no");
}

//window.onload = onload_handler;
/// ���ݵ�λת������
function ChangeDose(unit,dose){

	if (unit == ""){
		return dose;
	}
	
	///  ��λ�а���������ҩ
	if ((unit.indexOf("/kg") !=-1 )|| (unit.indexOf("/KG") !=-1 )){
		var height =  $("#Height").val();    /// ���
		var weight = $("#Weight").val();     /// ����
		dose = (weight=="")?dose:dose*weight;
		return dose;
	}
	
	///  ��λ�а���������
	if ((unit.indexOf("/m2") !=-1 )|| (unit.indexOf("/M2") !=-1 )){
		var height =  $("#Height").val();    /// ���
		var weight = $("#Weight").val();     /// ����
		if ((height=="")||(weight=="")) return dose;
		var area=(0.0061*height)+(0.0128*weight)-0.1529
		dose = (area=="")?dose:dose*area;
		
		return dose;
	}
	
	return dose;
}

/// ���ݵ�λת������
function ChangeUnit(unit){

	if (unit == ""){
		return unit;
	}

	if (unit.indexOf("/") !=-1){
		var unitArr = unit.split("/");
		unit  = unitArr[0];
		return unit;
	}
	
	return unit;
}

//��ǰ����תΪyyyy-mm-dd
function toDDMMMYYYY() {  
	var nowDate = new Date();
	 var year = nowDate.getFullYear();
	 var month = nowDate.getMonth() + 1 < 10 ? "0" + (nowDate.getMonth() + 1)
	  : nowDate.getMonth() + 1;
	 var day = nowDate.getDate() < 10 ? "0" + nowDate.getDate() : nowDate
	  .getDate();
	 var dateStr = year +"-"+ month +"-"+ day;
	 return dateStr;
}

var FormatterType = function(val, row, index) {
	if(val=="sym") return "֢״"
    return val;

}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
