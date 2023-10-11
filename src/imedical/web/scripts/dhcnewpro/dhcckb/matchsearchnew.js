/**
*	Author: 		Qunianpeng
*	Create: 		2019/05/15
*	Description:	ҩƷ��Ϣ���뼰��ѯ
*/
var mDel1 = String.fromCharCode(1);  /// �ָ���
var mDel2 = String.fromCharCode(2);  /// �ָ���
var pid="";
/// ҳ���ʼ������
function initPageDefault(){
	InitCombobox();
	InitPatEpisodeID();		/// ��ʼ�����ز��˾���ID
	InitButton();			/// ��ʼ����ť���¼�
	InitDrugListGrid();		/// ��ʼ��ҩƷ�б�
	
}
//shy 2020-12-3
function InitCombobox()
{
		var cbox = $HUI.combobox("#searchitem",{
		valueField:'id', textField:'text', multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:true,
		data:[
			{id:'43',text:'��Ʒ��(��ҩ)'},  
			{id:'74532',text:'������ͨ����(��ҩ)'},
			{id:'81818',text:'������ͨ����(�г�ҩ)'},
			{id:'44',text:'����(��ҩ)'},
			{id:'81835',text:'����(�г�ҩ)'},
			{id:'78015',text:'��׼�ĺ�(��ҩ)'},         //shy 2021/6/17
			{id:'81832',text:'��׼�ĺ�(�г�ҩ)'},       //shy 2021/6/17
			{id:'77980',text:'���'},
			{id:'40',text:'����'},
			{id:'114554',text:'��ҩ��Ƭƥ��'},
			{id:'74531',text:'��Ч��λ(��Ч����)'}      //shy 2021/6/20
		],
		formatter:function(row){  
			var rhtml;
			if(row.selected==true){
				rhtml = row.text+"<span id='i"+row.id+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.text+"<span id='i"+row.id+"' class='icon'></span>";
			}
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
	var cbox = $HUI.combobox("#searchitem2",{
		valueField:'id', textField:'text', multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:true,
		data:[
			{id:'43',text:'��Ʒ��(��ҩ)'},  
			{id:'74532',text:'������ͨ����(��ҩ)'},
			{id:'81818',text:'������ͨ����(�г�ҩ)'},
			{id:'44',text:'����(��ҩ)'},
			{id:'81835',text:'����(�г�ҩ)'},
			{id:'78015',text:'��׼�ĺ�(��ҩ)'},         //shy 2021/6/17
			{id:'81832',text:'��׼�ĺ�(�г�ҩ)'},       //shy 2021/6/17
			{id:'77980',text:'���'},
			{id:'40',text:'����'},
			{id:'114554',text:'����Ӧ��(��ҩ��Ƭ)'},
			{id:'74531',text:'��Ч��λ(��Ч����)'}      //shy 2021/6/20
		],
		formatter:function(row){  
			var rhtml;
			if(row.selected==true){
				rhtml = row.text+"<span id='i"+row.id+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.text+"<span id='i"+row.id+"' class='icon'></span>";
			}
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
	var cbox = $HUI.combobox("#showitem",{
		valueField:'id', textField:'text', multiple:true,selectOnNavigation:false,panelHeight:"auto",editable:true,
		data:[
			{id:'74532',text:'������ͨ����(��ҩ)'},
			{id:'81818',text:'������ͨ����(�г�ҩ)'},
			{id:'114554',text:'����Ӧ��(��ҩ��Ƭ)'},
			{id:'44',text:'����(��ҩ)'},
			{id:'81835',text:'����(�г�ҩ)'},
			{id:'77980',text:'���'},
			{id:'40',text:'����'},
			{id:'74531',text:'��Ч��λ(��Ч����)'},
			{id:'78012',text:'��װ'},
			{id:'78015',text:'��׼�ĺ�'}
		],
		formatter:function(row){  
			var rhtml;
			if(row.selected==true){
				rhtml = row.text+"<span id='i"+row.id+"' class='icon icon-ok'></span>";
			}else{
				rhtml = row.text+"<span id='i"+row.id+"' class='icon'></span>";
			}
			return rhtml;
		},
		onChange:function(newval,oldval){
			$(this).combobox("panel").find('.icon').removeClass('icon-ok');
			for (var i=0;i<newval.length;i++){
				$(this).combobox("panel").find('#i'+newval[i]).addClass('icon-ok');
			}
		}
	});
	
	
}

/// ��ʼ�����ز��˾���ID
function InitPatEpisodeID(){
	
	PatientID = getParam("PatientID");
	EpisodeID = getParam("EpisodeID");	
}

/// ��ʼ����ť���¼�
function InitButton(){

	/// ����
	//$('#calc').on("click",CalcClick); 

	/// ���룬��Ʒ���س�	
	//$('#queryCode,#queryDesc').bind('keypress',InputPrese);
	$('#queryDesc').bind('keypress',InputPrese);
	
	

}

/// ��ʼ��ҩƷ�б�
function InitDrugListGrid(){

	var  columns=[[    
	       	{field:'num',title:'���',width:40}, 
	       	{field:'drugCode',title:'ҩƷ����',width:100},     
	        {field:'drugName',title:'ҩƷ����',width:180},
	        {field:'drugDataType',title:'ҩƷ�ֵ�',width:100},
	        {field:'libDrugCode',title:'֪ʶ��ҩƷ����',width:180},  
	        {field:'libDrugName',title:'֪ʶ��ҩƷ����',width:180}, 
	        {field:'libDrugDataType',title:'֪ʶ��ҩƷ�ֵ�',width:100}, 
	        {field:'generName',title:'������ͨ����',width:120},
	        /* {field:'proName',title:'��Ʒ��',width:200}, */
	        {field:'factory',title:'����',width:240},
	        {field:'matchFlag',title:'��ע',width:120}
	    ]]
	
	///  ����datagrid
	var option = {		
		toolbar:'#toolbar',
		border:false,
	    rownumbers:true,
	    //fitColumns:true,
	    singleSelect:true,
	    pagination:true,
	    pageSize:20,
	    pageList:[20,40,100],
		//showHeader:false,
		//fitColumn:true,
		rownumbers : false,
		singleSelect : true,
	    fit:true,	
	    checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
			window.open("dhcckb.editprop.csp?parref="+rowData.dicDrugID);
        },
	    onLoadSuccess: function (data) { //���ݼ�������¼�
	    
	    //showSuccessMount(LgUserID);
          
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBMatchSearch&MethodName=QueryDrugList&params="+"^^^"+LgUserID;
	new ListComponent('druglist', columns, uniturl, option).Init();
}
function showSuccessMount(LgUserID)
{

	var resultData="";
	
	runClassMethod("web.DHCCKBMatchSearch","GetSuccessData", {"LgUserID":LgUserID}, function (ret) {
       resultData =ret;
       if(resultData!="")
		{
			var allCount=resultData.split("^")[0];
			var successCount=resultData.split("^")[1];
			var successCountPv=resultData.split("^")[2];
			$.messager.alert("��ʾ","ƥ������:"+allCount+",ƥ������:"+successCount+",ƥ����:"+successCountPv+"%");	
		}
    }, "text", true);	
	
	
}

/// ��ѯ
function Query(){
	
	var code = "" //$("#queryCode").val().trim();
	var desc = $("#queryDesc").val().trim();
	var params = code +"^"+ desc +"^"+ pid+"^"+LgUserID;

	$("#druglist").datagrid("load",{"params":params});

}


/// ���룬�����س��¼�
function InputPrese(e){

	 if(e.keyCode == 13){
		Query();
	}
}

/// ��������
function UploadData(searchModel){
	
	var wb;//��ȡ��ɵ�����
	var rABS = false; //�Ƿ��ļ���ȡΪ�������ַ���
    //var files = $("#articleImageFile")[0].files;
    var files = $("#filepath").filebox("files");
    if (files.length == 0){
		$.messager.alert("��ʾ:","��ѡ���ļ������ԣ�","warning");
		return;   
	}
	
	$.messager.progress({ title:'���Ժ�', msg:'�������ڵ�����...' });
	pid=serverCall("web.DHCCKBMatchSearch","MatchDataPid");  
	var binary = "";
    var fileReader = new FileReader();
    fileReader.onload = function(ev) {
        try {
            //var data = ev.target.result;
			var bytes = new Uint8Array(ev.target.result);
			var length = bytes.byteLength;
			for(var i = 0; i < length; i++) {
				binary += String.fromCharCode(bytes[i]);
			}
			if(rABS) {
				wb = XLSX.read(btoa(fixdata(binary)), {//�ֶ�ת��
					type: 'base64'
				});
			} else {
				wb = XLSX.read(binary, {
					type: 'binary'
				});
			}
                //persons = []; // �洢��ȡ��������
        } catch (e) {
			$.messager.alert("��ʾ:","�ļ����Ͳ���ȷ��","warning");
			$.messager.progress('close');
			return;
        }

		var obj = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
		if(!obj||obj==""){
			$.messager.alert("��ʾ:","��ȡ�ļ�����Ϊ�գ�","warning");
			$.messager.progress('close'); 
			return;
		}
		var Ins = function(n){
			if (n >= obj.length){	
			   	MatchSearch(searchModel);
				//$("#druglist").datagrid("reload");   /// ˢ��ҳ������	  sunhuiyong  ע��  2021-4-21
				
		//shy 2021-3-15	
		var Search=$HUI.combobox("#searchitem").getValues();   
		var selectitem=""
		for(var i=0;i<Search.length;i++)
		{
			if(selectitem=="")
			{
				selectitem=Search[i];
			}else
			{
				selectitem=selectitem+"^"+Search[i];
			}
		}
		var Show=$HUI.combobox("#showitem").getValues();   
		var showitem=""
		for(var i=0;i<Show.length;i++)
		{
			if(showitem=="")
			{
				showitem=Show[i];
			}else
			{
				showitem=showitem+"^"+Show[i];
			}
		}
		runClassMethod("web.DHCCKBMatchSearch","getCKBColumn",
		{
			showitem:showitem,
			selectitem:selectitem
		},function(ret){
			var columns=[];
			for(var i=0;i<ret.length;i++){
				if(ret[i].field=="num"){
					columns.push({field: "num", title: ret[i].title,width:40})
				}else if(ret[i].field=="drugCode"){
					columns.push({field: "drugCode", title: ret[i].title,width:100})
				}else if(ret[i].field=="drugName"){
					columns.push({field: "drugName", title: ret[i].title,width:180})
				}else if(ret[i].field=="libDrugCode"){
					columns.push({field: "libDrugCode", title: ret[i].title,width:100})
				}else if(ret[i].field=="libDrugName"){
					columns.push({field: "libDrugName", title: ret[i].title,width:180})
				}else if(ret[i].field=="DrugForm"){
					columns.push({field: "DrugForm", title: ret[i].title,width:100})
				}else if(ret[i].field=="itmSpecificationype"){
					columns.push({field: "itmSpecificationype", title: ret[i].title,width:100})
				}
				else{
					columns.push(ret[i])	
				}
			}
				$('#druglist').datagrid({
					fit:true,
					columns:[columns]
				})
				$("#druglist").datagrid("reload");   /// ˢ��ҳ������		
				$.messager.progress('close');
		})
			}else{
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {
					/* var mListDataArr = []; var mListTitleArr = [];
					for(x in obj[m])  {
					   if (m == 0){
					   	  mListTitleArr.push(x);
					   }
					   mListDataArr.push(obj[m][x]||"");
					}
					if (m == 0){
				   	   TmpArr.push(mDel1 + mListTitleArr.join("[next]"));
				    }
					TmpArr.push(mDel1 + mListDataArr.join("[next]")); */
					var mListData = mDel1 + obj[m].itmCode +"[next]"+ obj[m].itmDrugCode +"[next]"
									+ ChangeValue(obj[m].itmDrugName) +"[next]"+  (ChangeValue(obj[m].itmGeneric)||"") +"[next]"
									+ChangeValue(obj[m].itmManf) +"[next]"+ChangeValue(obj[m].itmSpecificationype)+"[next]"+ChangeValue(obj[m].itmDrugForm)
									+"[next]"+ChangeValue(obj[m].itmDrugDataType)+"[next]"+ChangeValue(obj[m].itmApprovalNum)+"[next]"+ChangeValue(obj[m].itmEquivalent)
					TmpArr.push(mDel1 + mListData);
					if ((m != 0)&(m%100 == 0)){
						/// ��ʱ�洢����
						InsTmpGlobal(TmpArr.join(mDel2), Ins, m+1);
						TmpArr.length=0;
						break;
					}
				}
				if (TmpArr.join(mDel2) != ""){
					/// ��ʱ�洢����
					InsTmpGlobal(TmpArr.join(mDel2), Ins, m);
				}
			}
		}
		Ins(0);	//�ӵ�һ�п�ʼ��		
  
   }
   fileReader.readAsArrayBuffer(files[0]);
   //Query();
   //Query();
  
}

//�ļ���תBinaryString
function fixdata(data) { 
	var o = "",
		l = 0,
		w = 10240;
	for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	return o;
}

/// ��ʱ�洢����
function InsTmpGlobal(mListData, Fn, m){

	var ErrFlag = 0;
	runClassMethod("web.DHCCKBMatchSearch","MatchTmpData",{"pid":pid,"mListData":mListData,"LgUserID":LgUserID},function(val){
		Fn(m);
	})

	return ErrFlag;
}

/// ƥ�����
function MatchSearch(searchModel){
	var Search=$HUI.combobox("#searchitem").getValues();   //shy 2020-12-4 ���ƥ����
	var Searchstr=""
	for(var i=0;i<Search.length;i++)
	{
		if(Searchstr=="")
		{
			Searchstr=Search[i];
		}else
		{
			Searchstr=Searchstr+"^"+Search[i];
		}
	}
	var Search2=$HUI.combobox("#searchitem2").getValues();   //shy 2020-12-4 ���ƥ����
	var Searchstr2=""
	for(var i=0;i<Search2.length;i++)
	{
		if(Searchstr2=="")
		{
			Searchstr2=Search2[i];
		}else
		{
			Searchstr2=Searchstr2+"^"+Search2[i];
		}
	}
	//searchModel = 1; // qnp 2021/1/13 ��ʱ�ָ���֮ǰ��ƥ���㷨
	//runClassMethod("web.DHCCKBMatchSearch","MatchSearch", {"pid":pid,"searchModel":searchModel}, function (ret) {
	if(searchModel=="0")
	{
		runClassMethod("web.DHCCKBMatchSearch","MatchSearchByDataListJobNew", {"pid":pid,"searchModel":Searchstr,"searchModelTwice":Searchstr2,"lgUserID":LgUserID}, function (ret) {
        //retvalArr = ret.replace(/(^\s*)|(\s*$)/g, "").split("@@");
        Query();
    }, "text", true);
	}else
	{
	runClassMethod("web.DHCCKBMatchSearch","MatchSearchByDataListDic", {"pid":pid,"searchModel":Searchstr,"lgUserID":LgUserID}, function (ret) {
        //retvalArr = ret.replace(/(^\s*)|(\s*$)/g, "").split("@@");
        Query();
    }, "text", true);		
	}
}

/// ����
function ExportMatchData(){
	
	runClassMethod("web.DHCCKBMatchSearch","ExportMatchData", {"pid":pid,"LgUserID":LgUserID}, function (ret) {
        retvalArr = ret.replace(/(^\s*)|(\s*$)/g, "").split("@@");
    }, "text", false);
    if (retvalArr == "") {
        $.messager.alert("��ʾ:", "ȡ���ݴ���","info");
        return;
    }
    
    var filePath=browseFolder();
	if (typeof filePath=="undefined"){
		$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
		return;
	}
	
    //1����ȡXLS����·��
    var path = tkMakeServerCall("web.DHCDocConfig", "GetPath");
    var Template = path + "DHCCKB_ExportMatchData.xls";

    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var objSheet = xlBook.ActiveSheet;
    
    
    //var adrRepDrgItmArr=adrRepDrgItmList.split("||");
	for(var k=0;k<retvalArr.length;k++){
		var itmArr=retvalArr[k].split("[next]");
		objSheet.Cells(k+1,1).value=itmArr[0]; //���
		objSheet.Cells(k+1,2).value=itmArr[1]; //ҩƷcode
		objSheet.Cells(k+1,3).value=itmArr[2]; //ҩƷ����
		//objSheet.Cells(k+1,4).value=itmArr[3]; //�ֵ�����
		objSheet.Cells(k+1,4).value=itmArr[3]; //ͨ����
		objSheet.Cells(k+1,5).value=itmArr[4]; //������ҵ
		objSheet.Cells(k+1,6).value=(((itmArr[5]=="")||(itmArr[5]==undefined))?itmArr[5]:itmArr[5].toString()); //��ע
	}  

    xlBook.SaveAs(filePath + formatDate(0)+"ҩƷƥ������" + ".xls");
    //xlApp=null;
    xlBook.Close(savechanges=false);
    xlApp.Visible = false; 
    objSheet = null;
    $.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
}


/// ����
function ExportMatchDataNew(){
	
	var rtn = $cm({
		dataType:'text',
		ResultSetType:"Excel",
		ExcelName:formatDate(0)+"ҩƷƥ������", //Ĭ��DHCCExcel
		ClassName:"web.DHCCKBMatchSearch",
		QueryName:"ExportMatchDataNew",
		pid:pid,
		LgUserID:LgUserID
	},false);
	//web.Util.Menu SelectGroupMenu
	location.href = rtn;
}



function ChangeValue(val){

	if (val === undefined){
		val = ""
	}
	return val;
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })

/// ƥ����� LoginInfo ClientIPAdd
function ContrastMatchData(){

	runClassMethod("web.DHCCKBMatchSearch","ContrastMatchData", {"loginInfo":LoginInfo,"clientIP":ClientIPAdd,"LgUserID":LgUserID}, function (ret) {
       if(ret=="0"){
	     $.messager.alert("��ʾ","������ɣ�");
		}else{
		 $.messager.alert("��ʾ","����ʧ�ܣ�");
		}
    }, "text", true);
}
// ƥ������ʾ����
function showWin()
{
	var  columns=[[    
	       	{field:'matchItem',title:'ƥ����',align:'center',width:240}, 
	       	{field:'marchAll',title:'����',align:'center',width:110},
	       	{field:'onMatch',title:'ƥ����',align:'center',width:110},     
	        {field:'matchLv',title:'ƥ����',align:'center',width:100}
	        
	    ]]
	
	///  ����datagrid
	var option = {		
		border:false,
	    rownumbers:true,
	    singleSelect:true,
		rownumbers : false,
		singleSelect : true,
	    fit:true,	
	    checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
			
        },
	    onLoadSuccess: function (data) { 
	    
          
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBMatchSearch&MethodName=GetSuccessData&lgUserID="+LgUserID;
	new ListComponent('LvList', columns, uniturl, option).Init();
	
	$HUI.dialog("#PPLv").open();
	
}