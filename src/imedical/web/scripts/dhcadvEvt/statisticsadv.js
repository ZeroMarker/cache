///qqa
///2017-12-14
///
$(function (){
	initParam();
	
	initCombobox();
	
	initDateBox();
	
	initMehtod();
	
	initDatagrid();
	
	setStatComboDis();  //����ͳ����Ŀ��ʼ��ΪĬ��״̬
})
///��ʼ�����в���
function initParam(){
	
	imgResizeFlag=false;
	
	setParams={
		showNoItm:false,      //�Ƿ���ʾ��ѡ��
	}
	
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
		endDate:"",
		columnItm:[]
	}
	
	statDataType="";  //��ǰͳ�Ʊ�־
	
	
	
	runClassMethod("web.DHCADVStatisticsDhcadv","InitColumnData",{},
		function (data){
						
		}
	)
}

///��ʼ��table
function initDatagrid(){
	
	var columns = [[
    {
        field: 'StRowID',
        title: 'ID',
        hidden:true
    },{
        field: 'StTempName',
        title: 'ģ������',
        width: 100
    },{
        field: 'StatTypeXVal',
        title: 'XValue',
        hidden:true
    },{
        field: 'StatTypeXText',
        title: 'ͳ�ƺ���',
        width: 50
    },{
        field: 'StatTypeYVal',
        title: 'YValue',
        hidden:true
    },{
        field: 'StatTypeYText',
        title: 'ͳ������',
        width: 50
    },{
        field: 'StatDataVal',
        title: 'DataValue',
        hidden:true
    },{
        field: 'StatDatText',
        title: 'ͳ������',
        width: 50
    },{
        field: 'StatTypeVal',
        title: 'TypeValue',
        hidden:true
    },{
        field: 'StatTypeText',
        title: 'ͳ������',
        width: 50
    },{
	 	field: 'delete1',
        title: '����',
        formatter:function(value, rowData, rowIndex){
	    	return "<a href='#' onclick='deleteTemp(\""+rowData.StRowID+"\")'>ɾ��</a>";    
	    }   
	 },{
	 	field: 'cite1',
        title: '����',
        formatter:function(value, rowData, rowIndex){
	        var tempData = rowData.StatTypeXVal+"!!"+rowData.StatTypeYVal+"!!"+rowData.StatDataVal+"!!"+rowData.StatTypeVal+"!!"+rowData.StatTypeText;
	    	return "<a href='#' onclick='setStatCombTemp(\""+tempData+"\")'>����</a>";    
	    }   
	 }]]

	$("#tmpDataTable").datagrid({
		url: 'dhcapp.broker.csp?ClassName=web.DHCADVStatTemp&MethodName=GetJsonList',
		fit:true,
		fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:60,  
		pageList:[60], 
		loadMsg: '���ڼ�����Ϣ...',
		rownumbers : false,
		pagination:true,
		singleSelect:true,
		selectOnCheck: false,
		checkOnSelect: false,
		headerCls:'panel-header-gray', //ed
		onDblClickRow:function(index,row){
			
		}
	})		
}


function deleteTemp(stRowId){
	
	if (stRowId != null) {
		$.messager.confirm("��ʾ", "��ȷ��Ҫɾ����Щ������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				var ret=serverCall("web.DHCADVStatTemp","Delete",{"StRowID":stRowId});
				if(ret!=0) $.messager.alert("��ʾ","ɾ��ʧ�ܣ�");
				if(ret==0) $.messager.alert("��ʾ","ɾ���ɹ���","info",function(){
						$("#tmpDataTable").datagrid("reload");
				});
				return;
			}
		});
	}else{
		 return;
	}
	
	
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
	return;
	
}

function initMehtod(){
	$("a:contains('���ɱ���')").on("click",initReportDatagrid);
	
	$(".statImgType").on("click",setSelImgType);
	
	$(".statImgType1").on("click",setSelImgType1);
}

function setSelImgType(){
	$(".statImgType").not(this).each(function(){
		$(this).removeClass("selStatImgType");	
	})
	if(!$(this).hasClass("selStatImgType")){
		$(this).toggleClass("selStatImgType");	
	}
	
	showEchartsPar();
	
}
function setSelImgType1(){
	$(".statImgType1").not(this).each(function(){
		$(this).removeClass("selStatImgType1");	
	})
	if(!$(this).hasClass("selStatImgType1")){
		$(this).toggleClass("selStatImgType1");	
	}
	
	showEchartsPar();
	
}
//getBeforeYearDate()
///��ʼ��������:��ʼ��ʱ��
function initDateBox(){
	$("#stDate").datebox("setValue",getBeforeYearDate());
	
	$("#endDate").datebox("setValue",getCurrentDate());	
}

function initCombobox(){
	
	//ģ��������ѡ�к���������comboboxֵ
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			setStatCombTemp(option.value);	
	    },
	    filter:function(q,row){
			var options = $("#reportTemplate").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
		}
	};
	var url = LINK_CSP+"?ClassName=web.DHCADVStatTemp&MethodName=GetTempList&FormNameID=";;
	new ListCombobox("reportTemplate",url,'',option).init();
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		valueField:'value',
		textField:'text',
		onSelect:function(option){
			resetTableAndComboBox();
			setStatComboEna();				
	    },
	    filter:function(q,row){
			var options = $("#reportType").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
		}
	};
	
	var url = uniturl+"JsonGetRepotType";
	new ListCombobox("reportType",url,'',option).init();	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    },
	    filter:function(q,row){
			var options = $("#statTypeX").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
		}
	};
	
	//var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	var url="";
	new ListCombobox("statTypeX",url,'',option).init();
	
	
	
	var uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=";
	var option = {
		
		valueField:'value',
		textField:'text',
		onSelect:function(option){
	       
	    },
	    filter:function(q,row){
			var options = $("#statTypeY").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
		}
	};
	
	//var url = uniturl+"JsonGetComboDataForStatField&FormNameID=''";
	var url ="";
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
		},
	    filter:function(q,row){
			var options = $("#statData").combobox("options");
			return row[options.textField].indexOf(q)!=-1;
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
		var fieldValue = (data[fieldName]==""?"��":data[fieldName]);
		var fieldValue = (data[fieldName]==undefined?"��":data[fieldName]);
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
	showEchartsPar();
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
		$.messager.alert("��ʾ","û�д�ͳ������,����Ƿ�ѡ���˱������ͣ�");
		return;
	}
	
	var dateXString="",dateXArr="",dateYString="",dateYArr="";
	//statData:��ͳ������
	//statTypeX:x field
	//statTypeY: y field
	//statTypeXDate,statTypeYDate :ʱ������ʱ����
	//statRadioXList,statRadioYList:radio����ȡ������Ԫ��
	///��ȡͳ�����ͣ���Ҫ�����Ƿ���ʱ������
	var statTypeXInfo = ($("#statTypeX").combobox("getValue")==undefined?"":$("#statTypeX").combobox("getValue"));  //�����X,json�����name
	var statTypeXDesc = ($("#statTypeX").combobox("getText")==undefined?"":$("#statTypeX").combobox("getText"));  //X����
	var statTypeX = statTypeXInfo.split("^")[0];
	var statTypeXDate="";
	if(statTypeXInfo.indexOf("^")!="-1"){
		statTypeXDate = statTypeXInfo.split("^")[1];	   //X��ʱ�䵥λ������������
	}
	var statTypeYInfo = ($("#statTypeY").combobox("getValue")==undefined?"":$("#statTypeY").combobox("getValue"));  //�����Y
	var statTypeYDesc = ($("#statTypeY").combobox("getText")==undefined?"":$("#statTypeY").combobox("getText"));  //Y����
	var statTypeY = statTypeYInfo.split("^")[0];
	var statTypeYDate = "";
	if(statTypeYInfo.indexOf("^")!="-1"){
		statTypeYDate = statTypeYInfo.split("^")[1];     //Y��ʱ�䵥λ������������	
	}
	
	var statType = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue"));
	var datagridColumX={},datagridColumY={},datagridColumNum = {},datagridData=[];  ///datagridColum����:������¼datagrid��column����������
	
	var statRadioXList="",statRadioYList="";            //radio��ʽ���λ�û��ȡ��radio�������Ԫ��
	if(statTypeX!="") statRadioXList = statAllDataObj.columnItm[statTypeX]==undefined?"":statAllDataObj.columnItm[statTypeX];
	if(statTypeY!="") statRadioYList = statAllDataObj.columnItm[statTypeY]==undefined?"":statAllDataObj.columnItm[statTypeY];   
	
	if((statTypeX==="")&&(statTypeX=="")){
		$.messager.alert("��ʾ","����ȷ��ͳ�ƺ����ͳ���������Ŀ��");
		$("#statXLable").css("color","red");
		$("#statYLable").css("color","red");
		return;
	}else{
		$("#statXLable").css("color","#000");
		$("#statYLable").css("color","#000");	
	}
	
	//����������ȡcolumn��ʱ��Ԫ��:��ͨԪ�غ�radio��Ԫ��
	if(statTypeXDate===""){   
		if(statRadioXList===""){
			for (i in statData){
				var data = 	statData[i];    
				var typeX = ((data[statTypeX]==""||data[statTypeX]==undefined)?"��":data[statTypeX]);
				datagridColumX[typeX]="";   //�������������¼������datagrid��column
			}
		}else{
			dateXArr = statRadioXList.split("^");   //��ȡradioParef����
			for (var i in dateXArr){
				var typeX = dateXArr[i];
				datagridColumX[typeX]="";   //�������������¼������datagrid��column
			}	
		}
	}else if(statTypeXDate!==""){
		dateXString = getDateInterval(stDate,endDate,statTypeXDate);   //��ʼʱ�䣬����ʱ�䣬ʱ����
		dateXArr = dateXString.split("^");   //��ȡʱ������
		for (var i in dateXArr){
			var typeX = dateXArr[i];
			datagridColumX[typeX]="";   //�������������¼������datagrid��column
		}
		
		
	}

	//��ȡcolumns����������Ϸ�������ȡͳ�ƺ�columns,����X�����������:
	var allDataColumns=[],allDataArray=[],count=1,myDymObj={};
	var noValueFlag=false,noValueObj={};  //��������ѡ��λ�����
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
		if(objName=="��"){
			noValueFlag=true;
			noValueObj = myDymObj;
		}else{
			allDataArray.push(myDymObj);
		}
		count=count+1;
	}

	if((noValueFlag)&&(setParams.showNoItm)) allDataArray.push(noValueObj);  //Ϊ�������޷������
	
	var myDymObj={};			//���һ��Ϊͳ��
	myDymObj.field="field"+count;
	myDymObj.align="center";
	myDymObj.title="�ϼ�";
	allDataArray.push(myDymObj);           //�������datagrid��columns
	//allDataColumns.push(allDataArray);   
	
	//Y��ʱ�����,��ʾY���в���
	if(statTypeYDate!==""){
		dateYString = getDateInterval(stDate,endDate,statTypeYDate);   //��ʼʱ�䣬����ʱ�䣬ʱ����
		dateYArr = dateYString.split("^");
	}
	//Y��radioParef����,��ʾY���в���
	if(statRadioYList!==""){
		dateYArr = statRadioYList.split("^");  //radio��Ԫ���б�
	}
	
	for(i in dateYArr){
		datagridColumY[dateYArr[i]]={};    //Y�᷽����ʾ���б���
		datagridColumNum[dateYArr[i]]={};  //
	}
	
	//����������ȡcolumn
	for (i in statData){
		var data = 	statData[i];
		var typeY = (data[statTypeY]==""?"��":data[statTypeY]);
		var typeX = (data[statTypeX]==""?"��":data[statTypeX]);   //XYȷ��һ����Ԫ��
		var typeY = (data[statTypeY]==undefined?"��":data[statTypeY]);
		var typeX = (data[statTypeX]==undefined?"��":data[statTypeX]);   //XYȷ��һ����Ԫ��
		//statTypeYDate ��ʱ������λ
		//formatDateType �ǵ�Ԫ��ʱ������ʱ������ĳ��ʱ��
		if(statTypeYDate!==""){						//ʱ��Y���ȡ
			typeY=formatDateType(typeY,dateYString)
		}
		
		//�������ö��󣬲�Ȼundefined����
		//datagridColumNum:����ͳ�ƺ����������:ԭ����ά���飬��һά��Ϊy,�ڶ�ά��Ϊx��ά���д������ֵ����ά������Ϊ������
		//qqa:2018-12-04:���ǵ����ݵĶ�ѡ��ͳ����Ҫ�ֿ�������Ҫ����ѭ��
		//limit:checkbox������ݷָ���
		//typeYLen:���ݳ���
		//typeYArr:��������
		var limit = String.fromCharCode(10);
		var typeYLen = typeY.split(limit).length;
		var typeYArr = typeY.split(limit);
		var typeXLen = typeX.split(limit).length;
		var typeXArr = typeX.split(limit);
		for(var i=0;i<typeYLen;i++){    
			typeY = typeYArr[i]==""?"��":typeYArr[i];
			if((!setParams.showNoItm)&&(typeY=="��")) continue;
			if(datagridColumNum[typeY]==undefined){   
				datagridColumNum[typeY]={};   //���óɶ���
			}
	
			datagridColumY[typeY]="";    //��
			
			//isHasData():�ж�ͳ�������ڵ�ǰ�������Ƿ�������
			if((statDataID==="")|((statDataID!=="")&(isHasData(data,statTypeDesc)))){
				if(statTypeXDate===""){      //��ʱ��
					for(var j=0;j<typeXLen;j++){ //ѭ��д������������Ϊʱ��Ԫ�ز���Ҫѭ��
						var typeItmX = typeXArr[j]==""?"��":typeXArr[j];
						if((!setParams.showNoItm)&&(typeItmX=="��")) continue;
						
						if(datagridColumNum[typeY][typeItmX]==undefined){
							datagridColumNum[typeY][typeItmX]=1;
						}else{
							datagridColumNum[typeY][typeItmX]=datagridColumNum[typeY][typeItmX]+1;   //����������ߵ�Ԫ������
						}
					}
				}else if(statTypeXDate!==""){ //ʱ��
					var typeItmX = formatDateType(typeX,dateXString);   //qqa�������ذ���ʱ��ͳ�Ƶ�,ʱ�����λ��
					if(datagridColumNum[typeY][typeItmX]==undefined){
						datagridColumNum[typeY][typeItmX]=1;
					}else{
						datagridColumNum[typeY][typeItmX]=datagridColumNum[typeY][typeItmX]+1;   //����������ߵ�Ԫ������
					}
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
		dymObj["name"] =objName;
		if(objName=="undefined"){
			dymObj["name"] = "�ϼ�";
		}
		
		dymObj["group"] =statTypeXDesc;
		dymObj["value"] =dataNumberXYX[objName];
		globleImgData.dataX.push(dymObj);
	}
	for (objName in datagridColumY){
		if(objName!="undefined"){
			var dymObj={};
			dymObj["name"] =objName;
			dymObj["group"] =statTypeYDesc;
			dymObj["value"] =dataNumberXYY[objName];
			globleImgData.dataY.push(dymObj);	
		}
	}
	showEchartsPar();  //��ʾͼ��
	
	
	//��ʾ����
	showAllReport(allDataArray,datas);
	
	return ;
}

///
function ordArrLis(arrayList){
	var dymArray=[];
	var hasNoFlag=false;
	for (name in arrayList){
		if(name=="��") hasNoFlag = true;
		if(name=="�ϼ�"){
			if(hasNoFlag) dymArray["��"]="";	
		}
		
		if(name!="��"){
			//ȡ����ѡ�����ʾ
			//dymArray[name]=""  
		}
	}
	return dymArray;
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
			showEchartsPar();
		},
	"json",false) 	
}

function showEchart(param,type){

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
	
	if(type=="pie"){
		showEchartPie(data);
	}else if(type=="bar"){
		showEchartBars(data);
	}else{
		showEchartBars(data);
	}
}


function showEchartsPar(){
	var selStatImgType = $(".selStatImgType").attr("data-type");
	var selStatImgType1 = $(".selStatImgType1").attr("data-type");
	showEchart(selStatImgType,selStatImgType1);
	return;	
}


	
function showEchartBars(data){
	debugger;
	var is_stack={
		grid:{		
			y2:110	
		},
		axisLabel: {
			show: true,
            interval: 0,
            rotate: 45,
            margion: 0,
            formatter:function(val){
	            return val;
           		//return val.split("").join("\n");
            }
        }
	}
	
	var option = ECharts.ChartOptionTemplates.Bars(data,'',is_stack); 
	option.title ={
		
	}
	var container = document.getElementById('typecharts');
	opt = ECharts.ChartConfig(container, option);
	ECharts.Charts.RenderChart(opt);	
}

function showEchartPie(data){
	var option = ECharts.ChartOptionTemplates.Pie(data); 
	option.title ={
		
	}
	var container = document.getElementById('typecharts');
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

//������Ҫдһ��table
function showAllReport(columns,datas){

	$('#reportDataAll').easyTable("destroy");
	
	//�ٶ�̫������table����
	$('#reportDataAll').easyTable({
		url:"",
		nowrap:true,
		columns:columns,
		data:datas,
		rownumbers:false,
		singleSelect:true,
		onLoadSuccess:function(data){
			//globleAllTableData =data;   //
			//statAllDataObj.data = data; //���洦������ǰ���������������������ǰ̨
		},
		onClickCell:function(field){
			//console.log(field);
			//allReportClickStat(field);
		}
	})
	
	return;
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
	//var params = stDate+"^"+endDate+"^^^^^^^"+value+"^^";
	var params = stDate+"^"+endDate+"^^^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^^"+value+"^^";
	
	var jsonColumn= [
			{field:"RepStaus",title:'*����״̬',align:'left',hidden:false},
			{field:'RepDate',title:'*��������',align:'left',type:'dateTime'},
			//{field:'PatID',title:'*�ǼǺ�',hidden:true},
			{field:'AdmNo',title:'*������',align:'left'},
			{field:'PatName',title:'*����',align:'left'},
			{field:'PatSex',title:'*�Ա�',align:'left'},
			{field:'PatAge',title:'*����',align:'left'},
			{field:'RepType',title:'*��������',align:'left'},
			{field:'OccurDate',title:'*��������',align:'left',type:'dateTime'},
			{field:'OccurLoc',title:'*��������',align:'left'},
			{field:'RepLoc',title:'*�������',align:'left'},
			{field:'LocDep',title:'*ϵͳ',align:'left'},	
			{field:'RepUser',title:'*������',align:'left'}
		]
	if(value!=0) jsonColumn=[{field:'LocDep',title:'*ϵͳ',align:'left'}];
	
	if(value!==""){
		runClassMethod("web.DHCADVStatisticsDhcadv","GetColumnsByFormNameID",{ForNameID:value},
			function (data){
				
				for(var i=0;i<data.length;i++){
					jsonColumn.push(data[i]);
				}			
			},'json',false
		)
	}
	
	setColumnCombo(jsonColumn);  //ͨ��ǰ̨��������ͳ�� **ͳ����
	
	//�ٶ�̫������table����
	$('#reportDataAll').easyTable({
		columns:jsonColumn,
		url:LINK_CSP+"?ClassName=web.DHCADVCOMMONPART&MethodName=QueryRepStatList", //huaxiaoying 2017-1-4 �淶����
		singleSelect:true,
		nowrap:true,
		queryParams:{
			StrParam:params
		},
		onLoadSuccess:function(data){
			globleAllTableData =data;   //
			statAllDataObj.data = data; //���洦������ǰ���������������������ǰ̨
		},
		onClickCell:function(field){
			allReportClickStat(field);
		}
		
	})
	
	return;
}

///ͳ��combobox��ʼ�� **��������combobox������ֵ
///ʱ��Ԫ�س��ְ�������ͳ������ط����Ŀ���
function setColumnCombo(jsonColumn){
	statAllDataObj.column=[];
	statAllDataObj.columnItm=[];  //radioParef��Ԫ���б�洢
	dateColumn=[];
	for (i in jsonColumn){
		var jsonObj = jsonColumn[i];
		var comboObj={};
		//if(jsonObj.hidden) continue;   //���ص��ֶβ�ͳ��
		if(jsonObj.field==""||jsonObj.field==undefined) continue;   //û�л���fieldΪ���˳�
		if(jsonObj.title==""||jsonObj.title==undefined) continue;	//û�л���titleΪ���˳�
		
		comboObj.value = jsonObj.field;
		comboObj.text = jsonObj.title;
		if(jsonObj.type=="dateTime"){    //����ɰ��պ�̨����������жϣ�web.DHCADVStatisticsDhcadv.GetColumnsByFormNameID
			dateColumn.push(comboObj);	 //�¼������⴦�������·����������������ʾ
		}else if(jsonObj.type=="radioParef"){ //�������radio�ĸ�Ԫ�ؽ������⴦��:��¼��ѡ�����͵���Ԫ��
			comboObj.type = jsonObj.type;
			statAllDataObj.columnItm[jsonObj.field]=jsonObj.itmList;
			if(setParams.showNoItm) statAllDataObj.columnItm[jsonObj.field]=statAllDataObj.columnItm[jsonObj.field]+"^��";   //��ͳ�Ƶ�ʱ�򣬻�ȡ��Ԫ��,����������һ����ͳ��û��ѡ��Ԫ�صı�����ס���ţ��		
			statAllDataObj.column.push(comboObj);
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
	$("#statTypeX").combobox("loadData",statAllDataObj.column);   //�����Ѿ���ʱ��Ԫ�ؽ��������⴦��
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

	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatisticsDhcadv&MethodName=JsonGetComboDataTypeByField&FieldName="+value;
	$("#statType").combobox("reload",uniturl);	
		
}

///��ȡ��һ��ʱ��
function getBeforeYearDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear()-1;
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	if(typeof(DateFormat)=="undefined"){ //2017-03-15 cy
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ 
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ 
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ 
			return Month+"/"+Day+"/"+Year;
		}else{ 
			return Year+"-"+Month+"-"+Day;
		}
	} 
	//return Year+"-"+Month+"-"+Day;
}
///��ȡ��ǰʱ��
function getCurrentDate(){
	var curr_Date = new Date();  
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	if(typeof(DateFormat)=="undefined"){ 
		return Year+"-"+Month+"-"+Day;
	}else{
		if(DateFormat=="4"){ 
			return Day+"/"+Month+"/"+Year;
		}else if(DateFormat=="3"){ 
			return Year+"-"+Month+"-"+Day;
		}else if(DateFormat=="1"){ 
			return Month+"/"+Day+"/"+Year;
		}else{ 
			return Year+"-"+Month+"-"+Day;
		}
	}
	//return Year+"-"+Month+"-"+Day;
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

function saveTemplate(){
	
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	if(formNameID=="") {
		$.messager.alert("��ʾ","�������Ͳ���Ϊ�գ�");
		return;
	}
	
	var statTypeXInfo = ($("#statTypeX").combobox("getValue")==undefined?"":$("#statTypeX").combobox("getValue")); 
	var statTypeYInfo = ($("#statTypeY").combobox("getValue")==undefined?"":$("#statTypeY").combobox("getValue")); 
	var statTypeXText = $("#statTypeX").combobox("getText");
	var statTypeYText = $("#statTypeY").combobox("getText");
	if((statTypeXInfo=="")&&(statTypeYInfo=="")) {
		$.messager.alert("��ʾ","����ȷ��ͳ�ƺ����ͳ���������Ŀ��");
		return;
	}
	
	var statData = ($("#statData").combobox("getValue")==undefined?"":$("#statData").combobox("getValue")); 
	var statType = ($("#statType").combobox("getValue")==undefined?"":$("#statType").combobox("getValue")); 
	var statDataText = $("#statData").combobox("getText");
	var statTypeText = $("#statType").combobox("getText");
	if(statType=="") {
		$.messager.alert("��ʾ","ͳ�����Ͳ���Ϊ�գ�");
		return;
	}
			
	$.messager.prompt("��ʾ","������ģ�������",function(tmpName){
		if(tmpName==undefined) return;
		if(tmpName=="") {
			$.messager.alert("��ʾ","ģ�����ֲ���Ϊ�գ�");
			return;
		}
		var params=""+"#$"+formNameID+"#$"+tmpName+"#$"+statTypeXInfo+"##"+statTypeXText;
		params = params+"!!"+statTypeYInfo+"##"+statTypeYText+"!!"+statData+"##"+statDataText;
		params = params+"!!"+statType+"##"+statTypeText;
		var ret=serverCall("web.DHCADVStatTemp","Save",{"Params":params});
		if(ret!=0) {
			if(ret=="-1"){
				$.messager.alert("��ʾ","�������Ѵ��ڣ�");
			}else{
				$.messager.alert("��ʾ","����ʧ�ܣ�");
			}
			return;
		}
		if(ret==0) $.messager.alert("��ʾ","����ɹ���","info",function(){
			//relTempComb();	
		});
		return;
	})
	
	
	return;
}

///�����¼���������excelͳ��
function exportExcelStat(exportData)
{ 
	
	var dataLen = exportData.length;
	if(dataLen==0){
		$.messager.alert("��ʾ","û�е�������,�����������赼���ı���!");
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
	var topRow=2;				 //���µ�һ����ʾͳ��ʱ���Ѿ�ͳ��������ɶ
	dataLen = dataLen+topRow;		
	xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,dataObjLen)).MergeCells = true; //�ϲ���Ԫ��
	xlApp.Range(xlApp.Cells(2,1),xlApp.Cells(2,dataObjLen)).MergeCells = true; //�ϲ���Ԫ��
	gridlist(objSheet,1,dataLen,1,dataObjLen);
	
	var statTypeX = $("#statTypeX").combobox("getText");
	var statTypeY = $("#statTypeY").combobox("getText");
	objSheet.Cells(1,1)="ʱ��:"+statAllDataObj.stDate+"��"+statAllDataObj.endDate;
	objSheet.Cells(2,1)="ͳ��:"+statTypeX+"/"+statTypeY;
	var row=topRow;
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
	//relTempComb();  //ģ��combobox���¼���
	showDataTable(formNameID);
	reloadAllCombobox();  //��ȫ��ǰ̨����
	
	//qqa 2018-11-19 �޸����̱�����ѡ�����ں����Ͳ���ͳ�ƣ����Ҳ�ѯ����������Ϊ���ɱ༭״̬
	
	$("#stDate").datebox("disable");
	$("#endDate").datebox("disable");
	
	/*
	if(formNameID==0){
		reloadAllCombobox();
	}else{
		reloadCombobox(formNameID);	
	}
	*/
}

///ģ�����¼���
function relTempComb(){
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	uniturl = LINK_CSP+"?ClassName=web.DHCADVStatTemp&MethodName=GetTempList&FormNameID="+formNameID;
	$("#reportTemplate").combobox("reload",uniturl);
	return;	
}

function setStatCombTemp(tmpData){	
	var tmpDataArr = tmpData.split("!!");
	$("#statTypeX").combobox("setValue",tmpDataArr[0]);
	$("#statTypeY").combobox("setValue",tmpDataArr[1]);
	$("#statData").combobox("setValue",tmpDataArr[2]);
	$("#statType").combobox("setValue",tmpDataArr[3]);
	$("#statType").combobox("setText",tmpDataArr[4]);
	$("#tmpWin").window("close");
	return;
}

function citeTemplate(){
	var formNameID = ($("#reportType").combobox("getValue")==undefined?"":$("#reportType").combobox("getValue"));
	if(formNameID==""){
		$.messager.alert("��ʾ","����ѡ��һ�������ͣ�");
		return;	
	}
	$("#tmpWin").window("open");
	$("#tmpDataTable").datagrid("load",{
		"ForNameID":formNameID	
	})
}

function echartsResize(){
	if(typeof(imgResizeFlag)=="undefined") return;
	if(!imgResizeFlag) {
		showEchartsPar();
		imgResizeFlag=true;
	}
	if(imgResizeFlag) {
		setTimeout(function(){imgResizeFlag=false},200);
	}
}

function setStatComboDis(){
	$("#statTypeX").combobox("disable");
	$("#statTypeY").combobox("disable");
	$("#statData").combobox("disable");
	$("#statType").combobox("disable");
	return;
}
function setStatComboEna(){
	
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
