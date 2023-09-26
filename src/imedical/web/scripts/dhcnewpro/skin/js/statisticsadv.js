///qqa
///2017-12-14
///
$(function (){
	initParam();
	
	initCombobox();
	
	initDateBox();
	
	initMehtod();
	
	initDatagrid();
	
	initPageDomDis();
})

///��ʼ�����в���
function initParam(){
	//���ͼ����ص�����
	globleImgData={
		dataX:"",
		dataY:"",
		data:""	
	};
	
	globleTableData={rows:[],totle:0};	
	
	globleAllTableData=[];   //�������
	
	///����ͳ����ȫ��ͳ�����ȫ�ֱ���
	statAllDataObj={
		column:[],
		data:[],
		exportData:[],
		stDate:"",
		endDate:""
	}
	
	statDataType="";  //��ǰͳ�Ʊ�־
	
	runClassMethod("web.DHCADVStatisticsDhcadv","InitColumnData",{},
		function (data){
						
		}
	)
}

///��ʼ��table
function initDatagrid(){
	
	
		
}

function initDataGrid(params){

	var pid = params.split("^")[0];
	var columNum= params.split("^")[1];
	var colArray=[];
	for(i=1;i<=columNum;i++){
		dymObj={};
		dymObj.field="field"+i;
		dymObj.align="center";
		dymObj.title="ֵ"+(i-1);
		colArray.push(dymObj);
	}
	
	var columns=[];
	columns.push(colArray);
	
	// ����datagrid
	$('#reportDataTable').datagrid({
		title:'',
		url:LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=GetTabeData", //huaxiaoying 2017-1-4 �淶����
		queryParams:{
			pid:pid
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    showHeader:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onLoadSuccess:function(data){
			globleTableData = data;
		},
	    onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
           
        }
	});
}

function initMehtod(){
	//$("a:contains('���ɱ���')").on("click",initReportDatagrid);
	
	//$("a:contains('��������')").on("click",exportExcelStatic);
	
	$("#createRep").on("click",initReportDatagrid);//hxy 2018-03-07
	$("#exportRep").on("click",exportExcelStatic); //hxy
	
	$(".statImgType").on("click",setSelImgType);
}

function setSelImgType(){
	$(".statImgType").not(this).each(function(){
		$(this).removeClass("selStatImgType");	
	})
	if(!$(this).hasClass("selStatImgType")){
		$(this).toggleClass("selStatImgType");	
	}
	
	showEchart($(".selStatImgType").attr("data-type"))
	
}
//getBeforeYearDate()
///��ʼ��������
function initDateBox(){
	$("#stDate").datebox("setValue",getBeforeYearDate());
	
	$("#endDate").datebox("setValue",getCurrentDate());	
}

function initCombobox(){
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			resetTableAndComboBox();
			setDisOrEnaDom(option.value);			
	    }
	};
	
	var url = uniturl+"JsonGetRepotType";
	new ListCombobox("reportType",url,'',option).init();	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       setBtnDisOrEnab();
	    }
	};
	
	var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	new ListCombobox("statTypeX",url,'',option).init();
	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       setBtnDisOrEnab();
	    }
	};
	
	var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	new ListCombobox("statTypeY",url,'',option).init();
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       reloadComboboxDataType(option.value);
	    },
	    onChange:function(newValue,oldValue){
		    if(newValue==""){
			   //���õ��ĸ�δ�˴�
			   reloadComboboxDataType("");
			}
		}
	};
	
	var url = uniturl+"JsonGetComboDataForStatFieldNoDate&FormNameID=''";
	new ListCombobox("statData",url,'',option).init();
	
	var uniturl = "";
	var option = {
		valueField:'value',
		textField:'text',
		onLoadSuccess:function(){
			var val = $(this).combobox("getData");
			$(this).combobox("select",val[0].value);
		}
	};
	
	var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	new ListCombobox("statType",url,'',option).init();
	
	
	reloadComboboxDataType("");
}

//����Ǻ��ķ�����
//��Ϊ��ȡcolumn������
function initReportDatagrid(){
	var formNameID = ($("#reportType").combobox("getValue")==undefined?0:$("#reportType").combobox("getValue"));
	
	/*
	if(formNameID==0){
		//�����ȫ�������,ͳ�Ƶ�����ΪMaster���е�����
		initAllReportTable();
		statDataType="ALL";    //�����������������ȫ�������ض�������
	}else{
		//����ǵ�һ��������ͳ�Ʊ���
		initReportTable();
		statDataType="";	
	}
	*/
	
	initAllReportTable();
	statDataType="ALL";    //�����������������ȫ�������ض�������
}

function getValue(statTypeID,allNumber,value){
	if(allNumber!=0){
		if(statTypeID==2){
			value = parseInt(value/allNumber*100)+"%";
		}else if(statTypeID==3){
			value = value+"/"+parseInt(value/allNumber*100)+"%";
		}
	}else{
		value=0;
	}	
	return value;
}

///���ĳ����Ԫ���ʱ��ͳ�Ƴ�����ͼ��
function allReportClickStat(fieldName){
	globleImgData.dataX="";
	globleImgData.dataY="";
	globleImgData.data="";
	var statData = statAllDataObj.data;
	statCellObj={};
	for (i in statData){
		var data = 	statData[i];
		var fieldValue = (data[fieldName]==""?"":data[fieldName]);
		var fieldValue = (data[fieldName]==undefined?"":data[fieldName]);
		if(statCellObj[fieldValue]==undefined){
			statCellObj[fieldValue]=1;	
		}else{
			statCellObj[fieldValue] = statCellObj[fieldValue]+1;	
		}
		//statCellObj[fieldValue]="";   //�������������¼������datagrid��column
	}
	
	globleImgData.dataX = [];
	
	for (var objName in statCellObj){
		var dymObj = {};
		dymObj["name"] =objName;
		dymObj["group"] ="";
		dymObj["value"] =statCellObj[objName];
		globleImgData.dataX.push(dymObj);
	}
	showEchart("X");
}


///��ʼ��ͳ���������ݱ������** ����ͳ����ǰ̨���ƣ���������ߺ�̨
///
function initAllReportTable(){
	var statData = statAllDataObj.data; 
	var stDate = statAllDataObj.stDate;    //��ʼʱ��
	var endDate = statAllDataObj.endDate;  //����ʱ��
	var statDataID = ($("#statData").combobox("getValue")==undefined?"":$("#statData").combobox("getValue"));   //ͳ������
	var statTypeInfo = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue"));   //�˴Ρ��ʡ��˴�+��
	
	var statTypeDesc = ""
	var statTypeID=1
	if(statTypeInfo!="") statTypeID=statTypeInfo.split("^")[1];
	if(statTypeInfo!="") statTypeDesc=statTypeInfo.split("^")[0];    //���һ��
	
	if( statData.length==0){
		$.messager.alert("��ʾ","û�д�ͳ�����ݣ�");
		return;
	}
	
	var dateXString="",dateXArr="",dateYString="",dateYArr="";
	
	
	///��ȡͳ�����ͣ���Ҫ�����Ƿ���ʱ������
	var statTypeXInfo = ($("#statTypeX").combobox("getValue")==undefined?"":$("#statTypeX").combobox("getValue"));  //�����X,json�����name
	var statTypeXDesc = ($("#statTypeX").combobox("getText")==undefined?"":$("#statTypeX").combobox("getText"));  //X����
	var statTypeX = statTypeXInfo.split("^")[0];
	var statTypeXDate="";
	if(statTypeXInfo.indexOf("^")!="-1"){
		statTypeXDate = statTypeXInfo.split("^")[1];	   //Xѡ������Ϊʱ������
	}
	var statTypeYInfo = ($("#statTypeY").combobox("getValue")==undefined?"":$("#statTypeY").combobox("getValue"));  //�����Y
	var statTypeYDesc = ($("#statTypeY").combobox("getText")==undefined?"":$("#statTypeY").combobox("getText"));  //Y����
	var statTypeY = statTypeYInfo.split("^")[0];
	var statTypeYDate = "";
	if(statTypeYInfo.indexOf("^")!="-1"){
		statTypeYDate = statTypeYInfo.split("^")[1];	
	}
	if((statTypeX=="")||(statTypeY=="")) {
		$.messager.alert("��ʾ","ͳ�ƺ����������Ϊ�գ�");
		return;	
	};
	var statType = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue"));
	var datagridColumX={},datagridColumY={},datagridColumNum = {},datagridData=[];  ///datagridColum����:������¼datagrid��column����������
	
	//����������ȡcolumn��ʱ��Ԫ��
	if(statTypeXDate===""){
		for (i in statData){
			var data = 	statData[i];    
			var typeX = ((data[statTypeX]==""||data[statTypeX]==undefined)?"":data[statTypeX]);
			datagridColumX[typeX]="";   //�������������¼������datagrid��column
		}
	}else if(statTypeXDate!==""){
		dateXString = getDateInterval(stDate,endDate,statTypeXDate);   //��ʼʱ�䣬����ʱ�䣬ʱ����
		dateXArr = dateXString.split("^");   //��ȡʱ������
		for (var i in dateXArr){
			var typeX = dateXArr[i];
			datagridColumX[typeX]="";   //�������������¼������datagrid��column
		}
		
		
	}

	//Yʱ��Ԫ�ػ�ȡ
	if(statTypeYDate!==""){
		dateYString = getDateInterval(stDate,endDate,statTypeYDate);   //��ʼʱ�䣬����ʱ�䣬ʱ����
		dateYArr = dateYString.split("^");
	}
	

	//��ȡcolumns
	var allDataColumns=[],allDataArray=[],count=1,myDymObj={};
	myDymObj.field="field"+count;  //���push�������õ�һ��λ�ñ�����ͳ��
	myDymObj.align="center";
	myDymObj.title="";
	allDataArray.push(myDymObj);
	count=count+1
	for (objName in datagridColumX){
		var myDymObj={};
		myDymObj.field="field"+count;
		myDymObj.align="center";
		myDymObj.title=objName;
		
		if((objName=="undefined")&&(statTypeX=="")){    //Xδѡ����,ֻͳ�ƺϼ�
			myDymObj.hidden=true;
		}
		allDataArray.push(myDymObj);
		count=count+1;
	}
	var myDymObj={};			//���һ��Ϊͳ��
	myDymObj.field="field"+count;
	myDymObj.align="center";
	myDymObj.title="�ϼ�";
	allDataArray.push(myDymObj);
	allDataColumns.push(allDataArray);   //�������datagrid��columns

	//Y��ʱ�����,��ʾY���в���
	for(i in dateYArr){
		datagridColumY[dateYArr[i]]={};
		datagridColumNum[dateYArr[i]]={};
	}
	
	//����������ȡcolumn
	for (i in statData){
		var data = 	statData[i];
		var typeY = (data[statTypeY]==""?"":data[statTypeY]);
		var typeX = (data[statTypeX]==""?"":data[statTypeX]);   //XYȷ��һ����Ԫ��
		var typeY = (data[statTypeY]==undefined?"":data[statTypeY]);
		var typeX = (data[statTypeX]==undefined?"":data[statTypeX]);   //XYȷ��һ����Ԫ��
		if(statTypeYDate!==""){						//ʱ��Y���ȡ
			typeY=formatDateType(typeY,dateYString)
		}
		
		//�������ö��󣬲�Ȼundefined����
		if(datagridColumNum[typeY]==undefined){
			datagridColumNum[typeY]={};   //���óɶ���
		}
	
		datagridColumY[typeY]="";    //��
		
		if((statDataID==="")|((statDataID!=="")&(isHasData(data,statTypeDesc)))){
			if(statTypeXDate===""){      //��ʱ��
				if(datagridColumNum[typeY][typeX]==undefined){
					datagridColumNum[typeY][typeX]=1;
				}else{
					datagridColumNum[typeY][typeX]=datagridColumNum[typeY][typeX]+1;   //����������ߵ�Ԫ������
				}
			}else if(statTypeXDate!==""){ //ʱ��
				typeX = formatDateType(typeX,dateXString);   //qqa�������ذ���ʱ��ͳ�Ƶ�,ʱ�����λ��
				if(datagridColumNum[typeY][typeX]==undefined){
					datagridColumNum[typeY][typeX]=1;
				}else{
					datagridColumNum[typeY][typeX]=datagridColumNum[typeY][typeX]+1;   //����������ߵ�Ԫ������
				}
			}
		}
	}
	
	datagridColumY["�ϼ�"]="";
	datagridColumNum["�ϼ�"]={};

	//��ȡ�ϼ�������
	var dataNumberXYX={},dataNumberXYY={},allNumber=0;    //������¼�ϼ�����,allNumber(��������)
	for (typeYName in datagridColumY){
		for (typeXName in datagridColumX){
			//�ж��ڶ�undefined�����
			if(dataNumberXYY[typeYName]==undefined) dataNumberXYY[typeYName]=0;
			if(dataNumberXYX[typeXName]==undefined) dataNumberXYX[typeXName]=0;
			if(datagridColumNum[typeYName][typeXName]==undefined) {
				datagridColumNum[typeYName][typeXName]=0;	
			}
			allNumber = allNumber+datagridColumNum[typeYName][typeXName];
			dataNumberXYX[typeXName] = dataNumberXYX[typeXName]+datagridColumNum[typeYName][typeXName];  //ĳ�еĺϼ�
			dataNumberXYY[typeYName] = dataNumberXYY[typeYName]+datagridColumNum[typeYName][typeXName];  //�еĺϼ�
		}
	}
	dataNumberXYY["�ϼ�"] = allNumber;
	//���ü�������
	var datas=[];  //dataNumberXY ������¼X����ϼƺ�Y����ϼ�
	for (typeYName in datagridColumY){           
		var dymObj={},count=1;									   //Yû��ѡ��,ͳ�ƺϼ�
		dymObj["field"+count] = typeYName;
		count = count+1;
		for (typeXName in datagridColumX){			
			if(typeYName==="�ϼ�"){
				dymObj["field"+count] = getValue(statTypeID,allNumber,dataNumberXYX[typeXName]);  //���һ�е�ֵ
				count = count+1;		
			}else{
				dymObj["field"+count] = getValue(statTypeID,allNumber,datagridColumNum[typeYName][typeXName]);
				count = count+1
			}
		}
		
		dymObj["field"+count] = getValue(statTypeID,allNumber,dataNumberXYY[typeYName]);  //���һ�е�ֵ
		datas.push(dymObj);
	}
	
	//���õ�������
	statAllDataObj.exportData = datas.slice(0,datas.length); //ǳcopy
	var exportDymObj={},count=1;
	exportDymObj["field"+count] = "";
	count=count+1;
	for (objName in datagridColumX){
		exportDymObj["field"+count] = objName;
		count=count+1;
	}
	exportDymObj["field"+count] = "�ϼ�";
	statAllDataObj.exportData.unshift(exportDymObj); //��һ�о��Ǳ��ı�ͷ
	
	
	//ALL�����Ҳ�ͼ����ʾ����,���ݸ�ʽ[{"name":"��","group":"���¼��Ƿ��ж�©��Ϊ","value":"1"},{"name":"��","group":"���¼��Ƿ��ж�©��Ϊ","value":"1"}]
	globleImgData.dataX=[];
	globleImgData.dataY=[];
	
	for (objName in datagridColumX){
		//objName = (objName=="undefined"?"�ϼ�":objName);
		var dymObj={};
		if (objName=="undefined") continue;
		
		dymObj["name"] =objName;
		//if(objName=="undefined"){
		//	dymObj["name"] = "�ϼ�";
		//}
		dymObj["group"] =statTypeXDesc;
		dymObj["value"] =dataNumberXYX[objName];
		globleImgData.dataX.push(dymObj);
	}
	
	for (objName in datagridColumY){
		if("�ϼ�"==objName) continue;
		var dymObj={};
		dymObj["name"] =objName;
		dymObj["group"] =statTypeYDesc;
		dymObj["value"] =dataNumberXYY[objName];
		globleImgData.dataY.push(dymObj);	

	}
		
	showEchart("X");  //��ʾͼ��
	
	
	//��ʾ����
	showAllReport(allDataColumns,datas);
	
	return ;
}

function isHasData(data,itmNames){
	var ret=false;
	if(itmNames=="") ret = true;
	var fieldName = "";
	for(var i =0;i<itmNames.split("#").length;i++){
		fieldName  = itmNames.split("#")[i];
		if((data[fieldName]!="")&&(data[fieldName]!=undefined)){
			ret = true;	
		}
	}
	return ret;
}

///��ʼ��ͳ�����ݱ��
function initReportTable(){
	$("#dataTableAll").hide();
	$("#dataTablePort").show();
	
	var formID = $("#reportType").datebox("getValue")
	var stDate = $("#stDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");
	var statTypeX = ($("#statTypeX").combobox("getValue")==undefined?"":$("#statTypeX").combobox("getValue"));
	var statTypeY = ($("#statTypeY").combobox("getValue")==undefined?"":$("#statTypeY").combobox("getValue"));
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	var statData = ($("#statData").combobox("getValue")==undefined?"":$("#statData").combobox("getValue"));
	var statType = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue"));
	
	if(formID==""){
		$.messager.alert("��ʾ","�������Ͳ���Ϊ��");
		return ;
	}
	
	if(statTypeX==""){
		$.messager.alert("��ʾ","ͳ��X���������Ͳ���Ϊ��");
		return ;
	}
	
	//if(statTypeY==""){
	//	$.messager.alert("��ʾ","ͳ��Y���������Ͳ���Ϊ��");
	//	return ;
	//}
	
	if(statType=="") {
		$.messager.alert("��ʾ","ͳ�����Ͳ���Ϊ��");
		return ;	
	}
	
	var Params = stDate+"#"+endDate+"#"+statTypeY+"#"+statTypeX+"#"+formNameID+"#"+statType  //���column���������ѭ������
	
	runClassMethod("web.DHCADVStatisticsDhcadv","JsonListDataTable",{Params:Params},
		function(ret){
			initDataGrid(ret);
			initEchart(ret.split("^")[0],$("#statTypeX").combobox("getText"),$("#statTypeY").combobox("getText"));
		},
	"text",false) 	
}



function initEchart(pid,DicXDesc,DicYDesc){
	alert(pid+":"+DicXDesc+":"+DicYDesc);
	runClassMethod("web.DHCADVStatisticsDhcadv","GetTabeImgDataAll",{pid:pid,DicXDesc:DicXDesc,DicYDesc:DicYDesc},
		function(ret){
			globleImgData.dataX=ret.DataX;
			globleImgData.dataY=ret.DataY;
			globleImgData.data=ret.Data;
			showEchart($(".selStatImgType").attr("data-type"));
		},
	"json",false) 	
}

function showEchart(param){

	var data="";
	if(param==="X"){
		data = globleImgData.dataX;
	}
	
	if(param==="Y"){
		data = globleImgData.dataY;
	}
	
	if(param==="XY"){
		data = globleImgData.data;
	}

	showEchartPie(data);
	showEchartBars(data);
}

	
function showEchartBars(data){
	var option = ECharts.ChartOptionTemplates.Bars(data); 
	option.title ={
		
	}
	var container = document.getElementById('typechartsbar');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(data){
	
	var option = ECharts.ChartOptionTemplates.Pie(data); 
	option.title ={
		
	}
	var container = document.getElementById('typechartspie');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

//����  ����
function SetCellOpUrl(value, rowData, rowIndex)
{   var RepID=rowData.RepID;         //����ID
	var RepTypeCode=rowData.RepTypeCode; //�������ʹ���
	var RepShareStatus=rowData.RepShareStatus  //����״̬
	var html = "";
	if (RepShareStatus == "����"){
		html = "<a href='#' onclick=\"newCreateConsultWin('"+RepID+"','"+RepTypeCode+"')\" style='margin:0px 5px;font-weight:bold;color:red;text-decoration:none;'>�鿴�ظ��б�</a>";
	}else{
		  html = "<a href='#' onclick=\"newCreateConsultWin('"+RepID+"','"+RepTypeCode+"')\">�鿴�ظ��б�</a>";
		}
    return html;
}

function showAllReport(columns,datas){
	destoryDataTable();
	$('#reportDataAll').datagrid({
		url:"",
		fit:true,
		rownumbers:true,
		columns:columns,
		data:datas,
		pageSize:10,  		// ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:false,
		onLoadSuccess:function(data){
			
		},
		onClickCell:function(index,field,value){
		
		}
	});	
}

function destoryDataTable(){
	//$('#reportDataAll').datagrid("destroy");	
}

///��ʾrec������
function showDataTable(value){
	destoryDataTable();
	
	$("#dataTableAll").show();
	$("#dataTablePort").hide();        //�л���ʾ�ı��
	
	
	var stDate = $("#stDate").datebox("getValue");
	var endDate = $("#endDate").datebox("getValue");
	if(value==0){
		value="";	
	}
	var params = stDate+"^"+endDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^"+value+"^^";
	
	
	var jsonColumn= [
			{field:"RepStaus",title:'����״̬',align:'center',hidden:false},
			{field:'RepDate',title:'��������',align:'center'},
			{field:'PatID',title:'�ǼǺ�',hidden:true},
			{field:'AdmNo',title:'������',align:'center'},
			{field:'PatName',title:'����',align:'center'},
			{field:'PatSex',title:'�Ա�',align:'center'},
			{field:'PatAge',title:'����',align:'center'},
			{field:'RepType',title:'��������',align:'center'},
			{field:'OccurDate',title:'��������',align:'center'},
			{field:'OccurLoc',title:'��������',align:'center'},
			{field:'RepLoc',title:'�������',align:'center'},
			{field:'LocDep',title:'ϵͳ',align:'center',hidden:true},	
			{field:'RepUser',title:'������',align:'center'}
			/*
			{field:"ck",checkbox:true,width:20,hidden:true},
			{field:'StatusLastID',title:'��һ״̬ID',width:100,align:'center',hidden:true},
			{field:'LkDetial',title:'����',width:100,align:'center',formatter:SetCellOpUrl,hidden:true},
			{field:"RepID",title:'RepID',width:80,hidden:true},
			{field:"recordID",title:'recordID',width:80,align:'center',hidden:true},
			{field:'RepShareStatus',title:'����״̬',width:80,align:'center',align:'center',hidden:true},
			{field:'StatusLast',title:'��һ״̬',align:'center',width:100,hidden:true},
			{field:'Medadrreceive',title:'����״̬',width:100,hidden:true},
			{field:'Medadrreceivedr',title:'����״̬dr',align:'center',width:80,hidden:true},
			{field:'RepTypeCode',title:'�������ʹ���',hidden:true},
			{field:'RepImpFlag',title:'�ص��ע',hidden:true},
			{field:'RepSubType',title:'����������',hidden:true},
			{field:'RepLevel',title:'�����¼�����',hidden:true},
			{field:'RepInjSev',title:'�˺����ض�',hidden:true},
			{field:'RepTypeDr',title:'��������Dr',hidden:true}	
			*/
		]
	
	if(value!==""){
		runClassMethod("web.DHCADVStatisticsDhcadv","GetColumnsByFormNameID",{ForNameID:value},
			function (data){
				
				for(var i=0;i<data.length;i++){
					jsonColumn.push(data[i]);
				}			
			},'json',false
		)
	}
	
	
	var columns=[]
	columns.push(jsonColumn);
	setColumnCombo(columns[0]);  //ͨ��ǰ̨��������ͳ�� **ͳ����
	
	// ����datagrid
	$('#reportDataAll').datagrid({
		title:'',
		data:null,
		url:LINK_CSP+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepStatList", //huaxiaoying 2017-1-4 �淶����
		queryParams:{
			StrParam:params
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:10,  		// ÿҳ��ʾ�ļ�¼����
		pageList:[30,60],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:false,
		onLoadSuccess:function(data){
			globleAllTableData =data.rows;   //
			statAllDataObj.data = data.rows; //���洦������ǰ���������������������ǰ̨
		},
		onClickCell:function(index,field,value){
			allReportClickStat(field);
		}
	});	
	return;
}

///ͳ��combobox��ʼ�� **��������combobox������ֵ
function setColumnCombo(jsonColumn){
	statAllDataObj.column=[];
	dateColumn=[];
	for (i in jsonColumn){
		var jsonObj = jsonColumn[i];
		var comboObj={};
		//if(jsonObj.hidden) continue;   //���ص��ֶβ�ͳ��
		if(jsonObj.field==""||jsonObj.field==undefined) continue;   //û�л���fieldΪ���˳�
		if(jsonObj.title==""||jsonObj.title==undefined) continue;	//û�л���titleΪ���˳�
		if(jsonObj.hidden) continue;
		comboObj.value = jsonObj.field;
		comboObj.text = jsonObj.title;
		if(jsonObj.title.indexOf("����")!=-1){
			dateColumn.push(comboObj);	
		}else{
			statAllDataObj.column.push(comboObj);  //�����������ͳ��X��Y������	
		}
	}
	

	for(j in dateColumn){
		var dateColumnObj = dateColumn[j];
		var comboDateObj={};
		for(i=1;i<=6;i++){
			comboDateObj={};
			comboDateObj.value = dateColumnObj.value+"^"+i;
			comboDateObj.text = dateColumnObj.text+"("+i+"��)";	
			statAllDataObj.column.push(comboDateObj);
		}
		
		comboDateObj={};
		comboDateObj.value = dateColumnObj.value+"^����";   //����
		comboDateObj.text = dateColumnObj.text+"(����)";
		statAllDataObj.column.push(comboDateObj);
		
		comboDateObj={};
		comboDateObj.value = dateColumnObj.value+"^����";   //����
		comboDateObj.text = dateColumnObj.text+"(����)";
		statAllDataObj.column.push(comboDateObj);
		
		comboDateObj={};
		comboDateObj.value = dateColumnObj.value+"^���";
		comboDateObj.text = dateColumnObj.text+"(���)";
		statAllDataObj.column.push(comboDateObj);
	}
}

function reloadAllCombobox(){
	$("#statTypeX").combobox("setValue","");
	$("#statTypeY").combobox("setValue","");
	$("#statData").combobox("setValue","");
	$("#statTypeX").combobox("loadData",statAllDataObj.column);
	$("#statTypeY").combobox("loadData",statAllDataObj.column);
	$("#statData").combobox("loadData",statAllDataObj.column);
	//$("#statType").combobox("loadData",statAllDataObj.column);
}

///���¼���
function reloadCombobox(value){
	
	$("#statTypeX").combobox("setValue","");
	$("#statTypeY").combobox("setValue","");
	$("#statData").combobox("setValue","");
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataForStatField&FormNameID="+value;
	$("#statTypeX").combobox("reload",uniturl);	
	$("#statTypeY").combobox("reload",uniturl);	
	
	
	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataForStatFieldNoDate&FormNameID="+value;
	$("#statData").combobox("reload",uniturl);	
}

function reloadComboboxDataType(value){
	$("#statType").combobox("setValue","");
	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataTypeByField&FieldName="+value;
	$("#statType").combobox("reload",uniturl);	
		
}

///��ȡ��һ��ʱ��
function getBeforeYearDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear()-1;
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}
///��ȡ��ǰʱ��
function getCurrentDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}



var LINK_CSP="dhcapp.broker.csp";
//��ǰ����
function runClassMethod(className,methodName,datas,successHandler,datatype,sync){
	var _options = {
		url : LINK_CSP,
		async : true,
		dataType : "json", // text,html,script,json
		type : "POST",
		data : {
				'ClassName':className,
				'MethodName':methodName
			   }
	};
	$.extend(_options.data, datas);
	var option={dataType:typeof(datatype) == "undefined"?"json":datatype,async:typeof(sync) == "undefined"?_options.async:sync};
	_options=$.extend(_options, option);
	return $.ajax(_options).done(successHandler);
}
function serverCall(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"",false)
	return ret.responseText
}


function serverCallJson(className,methodName,datas){
	ret=runClassMethod(className,methodName,datas,function(){},"json",false)
	return ret.responseText
}

///��������
function exportExcelStatic(){
	if(statDataType=="ALL"){
		exportExcelStat(statAllDataObj.exportData);
	}else{
		exportExcelStat(globleTableData.rows);
	}
}

///�����¼���������excelͳ��
function exportExcelStat(exportData)
{ 
	var dataLen = exportData.length;
	if(dataLen==0){
		$.messager.alert("��ʾ","û�е�������!");
		return;
	}
	
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add("");
	var objSheet = xlBook.ActiveSheet;
	//�ж���û��undefined
	var dataObjLen=0;
	for (var dataName in exportData[0]){
		dataObjLen++;
	}

	gridlist(objSheet,1,dataLen,1,dataObjLen);
	
	var row=0;
	for (i=0;i<dataLen;i++){
		row=row+1;
		col=0;
		var dataObj = exportData[i];  //��������
		for (var dataName in dataObj){
			col=col+1;
			objSheet.Cells(row,col).value=dataObj[dataName];
		}
	}
	//gridlist(objSheet,1,2,1,5);
	
	xlApp.Visible=true;
	objSheet=null;
}

///ʱ������:���ﰴ������
function getDateInterval(stDate,endDate,intervalValue){
	var ret="";
	if((intervalValue=="����")||(intervalValue=="����")||(intervalValue=="���")){
		ret = getDateIntervalString(stDate,endDate,intervalValue);
	}else{
		ret = getDateIntervalNum(stDate,endDate,intervalValue);
	}
	return ret;
}

///�ַ������ȺͰ���
function getDateIntervalString(stDate,endDate,intervalValue){
	var ret = ""; 
	var mYear = parseInt(stDate.split("-")[0]);
	var mMonth = parseInt(stDate.split("-")[1]);
	var mDay = parseInt(stDate.split("-")[2]);
	var eYear = parseInt(endDate.split("-")[0]);
	var date="";
	if(intervalValue=="����"){
		if((mMonth<4)&&(mMonth>=1)){
			date = mYear+"-01-01";
		}else if((mMonth<7)&&(mMonth>=4)){
			date = mYear+"-04-01";
		}else if((mMonth<10)&&(mMonth>=7)){
			date = mYear+"-07-01";
		}else if((mMonth<=12)&&(mMonth>=10)){
			date = mYear+"-10-01";
		}
		var lsDateString = getDateIntervalNum(date,endDate,3);  //������3����һ������

		var lsDateArray =  lsDateString.split("^");
		
		
		for(i=0;i<lsDateArray.length;i++){
			var mYear = parseInt(lsDateArray[i].split("-")[0]);
			var mMonth = parseInt(lsDateArray[i].split("-")[1]);
			if(mMonth==1){
				if(ret!=="") ret = ret+"^"+mYear+"���һ����";
				if(ret==="") ret = mYear+"���һ����";
			}else if(mMonth==4){
				if(ret!=="") ret = ret+"^"+mYear+"��ڶ�����";
				if(ret==="") ret = mYear+"��ڶ�����";
			}else if(mMonth==7){
				if(ret!=="") ret = ret+"^"+mYear+"���������";
				if(ret==="") ret = mYear+"���������";	
			}else if(mMonth==10){
				if(ret!=="") ret = ret+"^"+mYear+"����ļ���";
				if(ret==="") ret = mYear+"����ļ���";
			}
		}
	}else if(intervalValue=="����"){
		if((mMonth<7)&&(mMonth>=1)){
			date = mYear+"-01-01";
		}else if((mMonth<=12)&&(mMonth>=7)){
			date = mYear+"-07-01";
		}
		var lsDateString = getDateIntervalNum(date,endDate,6);  //������3����һ������

		var lsDateArray =  lsDateString.split("^");
		
		
		for(i=0;i<lsDateArray.length;i++){
			var mYear = parseInt(lsDateArray[i].split("-")[0]);
			var mMonth = parseInt(lsDateArray[i].split("-")[1]);
			if(mMonth==1){
				if(ret!=="") ret = ret+"^"+mYear+"�ϰ���";
				if(ret==="") ret = mYear+"�ϰ���";
			}else if(mMonth==7){
				if(ret!=="") ret = ret+"^"+mYear+"�°���";
				if(ret==="") ret = mYear+"�°���";
			}
		}
	}else if(intervalValue=="���"){
		for(date=mYear;date<=eYear;date++){
			if(ret!=="") ret = ret+"^"+date+"���";
			if(ret==="") ret = date+"���";
		}
	}
	return ret;
}


///1-12���»�ȡ
function getDateIntervalNum(stDate,endDate,intervalValue){
	var ret = ""; 
	var date=stDate;
 	if((intervalValue<1)||(intervalValue>12)) return;
 	//String����ǿ��ת��Ϊnumber
	if(typeof intervalValue=="string"){
		intervalValue = parseInt(intervalValue);
	}
	
	var mYear = parseInt(stDate.split("-")[0]);
	var mMonth = parseInt(stDate.split("-")[1]);
	var mDay = parseInt(stDate.split("-")[2]);
	var date = stDate;
	while(date<endDate){
		if(ret!=="") ret = ret+"^"+date;
		if(ret==="") ret = date;
		
		mMonth = mMonth+intervalValue;
		if(mMonth>12){
			mMonth = mMonth-12;
			mYear = mYear+1;
		}
		
		date = mYear+"-"+(mMonth<10?"0"+mMonth:mMonth)+"-"+(mDay<10?"0"+mDay:mDay);
	}
	return ret;	
}

//** �ȶ�ʱ�䣬��ȡͳ��ʱ���������ʱ�����λ��
function formatDateType(date,dateInterval){

	var dateIntervalArr = dateInterval.split("^");
	for (i=0;i<dateIntervalArr.length;i++){
		
		
		if(i==(dateIntervalArr.length-1)){
			if(formatterDate(dateIntervalArr[i])<=date){
				date = dateIntervalArr[i];
				return date;
			}
		}else{
			if((formatterDate(dateIntervalArr[i])<=date)&&(date<formatterDate(dateIntervalArr[i+1]))){
				date = dateIntervalArr[i];
				return date; 	
			}	
		}
	}
	return "";
}

///** ���ȡ������ʱ��ת��
function formatterDate(date){

	var ret="";
	ret = date.replace(/���һ����/g,"-01-01");
	ret = ret.replace(/��ڶ�����/g,"-04-01");
	ret = ret.replace(/���������/g,"-07-01");
	ret = ret.replace(/����ļ���/g,"-10-01");
	ret = ret.replace(/�ϰ���/g,"-01-01");
	ret = ret.replace(/�°���/g,"-07-01");
	ret = ret.replace(/���/g,"-01-01");
	return ret;
}

///����excel�����߿�
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2;
}

function resetTableAndComboBox(){
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	
	statAllDataObj.stDate = $("#stDate").datebox("getValue");
	statAllDataObj.endDate = $("#endDate").datebox("getValue");
	
	showDataTable(formNameID);
	reloadAllCombobox();  //��ȫ��ǰ̨����
	showEchartBars("");
	showEchartPie("");
}

function initPageDomDis(){
	$("#statTypeX").combobox("disable");
	$("#statTypeY").combobox("disable");
	$("#statData").combobox("disable");
	$("#statType").combobox("disable");	
	$("#createRep").attr("disabled","disabled");
	$("#exportRep").attr("disabled","disabled");
	return;
}

function setBtnDisOrEnab(){
	$("#createRep").removeAttr("disabled");
	$("#exportRep").removeAttr("disabled");
	
}

function setDisOrEnaDom(){
	$("#stDate").datebox("disable");
	$("#endDate").datebox("disable");
	$("#statTypeX").combobox("enable");
	$("#statTypeY").combobox("enable");
	$("#statData").combobox("enable");
	$("#statType").combobox("enable");
	return;
}


///���ý���
function commonReload(){
	window.location.reload();
	return;
	//resetTableAndComboBox();
}
//hxy ����ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}
