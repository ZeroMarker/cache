$(document).ready(function(){
	//setDefaultWidth();
	//alert("$URL="+$URL);
	setLayOut();   //ҳ�沼�����õķ���
	
	regAllevent(); //�¼�ע�᷽��
	bindEidtformul();
});



//�������������������������ŵ���ɵĶ�������
//���������͡�����������ֵ����Ϣ
//��������������� ��������������ж�
function checkExption(exption){
	var operatorArr=["&&","||","'","(",")"];            //���������
	
	//01 ��֤�����Ƿ�ƥ��
	var bracketsArr = new Array();       //�����Ƿ�ƥ����֤������
	var bracketsArrLen=0;
	var tmpStr="";
	for(index=0; index<exption.length; index++){
		tmpStr=exption.substr(index,1);
		if(tmpStr=="("){
			bracketsArrLen=bracketsArr.push(tmpStr);      //���Ž���ջ
		}
		if(tmpStr==")"){
			tmpStr=bracketsArr.pop();      //���ų���ջ
			if(tmpStr!="("){
				$.messager.alert("��ʾ","��ʽ�е����Ų�ƥ��") ;
				return false;
			}
		}
	}
	if(bracketsArr.length!=0){             //������Բ�ƥ��
		$.messager.alert("��ʾ","��ʽ�е����Ų�ƥ��") ;
		return false;
	}

	//02 �����ʽ����Ϊ ����� ���� ��������������
	//02-1 ���������������������
	var operatorObjArr = new Array();    //������Լ����ŵ�����
	var objOperator =null;
	var tmpOpt=null;
	var expIndex=0;
	var optIndex=-1;
	var operatorNums=operatorArr.length;    //��������Ŀ
	for(i=0; i<operatorNums; i++){
		expIndex=0;
		tmpOpt=operatorArr[i];    //������
		optIndex=exption.indexOf(tmpOpt,expIndex);    //��������� �ڱ��ʽ�е�λ�á�
		while(optIndex>-1){
			objOperator=new Object();
			objOperator.index=optIndex;                     //����λ��
			objOperator.name=tmpOpt;                        //�����������������������
			//0:������ 1������� 2������
			if((tmpOpt=="(")||(tmpOpt==")")){
				objOperator.type="2";  //2������
			}else{
				objOperator.type="1";  //1�������
			}
			operatorObjArr.push(objOperator);
			
			expIndex=optIndex+1;
			optIndex=exption.indexOf(tmpOpt,expIndex);    //��������� �ڱ��ʽ�е�λ�á�
		}
	}
	
	//02-2 ������ ���Ű���������С�������
	var tmpObj=null;
	var minIndex=0;
	var operatorArrLen=operatorObjArr.length;
	for(i=0; i<operatorArrLen; i++){
		tmpObj=operatorObjArr[i];
		for(j=i+1; j<operatorArrLen; j++){
			if(operatorObjArr[j].index<tmpObj.index){
				operatorObjArr[i]=operatorObjArr[j];
				operatorObjArr[j]=tmpObj;
				tmpObj=operatorObjArr[i];
			}
		}
	}
	//alert("operatorObjArr.length="+operatorObjArr.length);
	
	//02-3 ����������������������
	var optionsLen=0;
	var expObjArr = new Array();
	var expObjLen=0;
	var curretnIndex=0;
	var objOperator=null;       //����������
	var operatorIndex=0;        //����������
	var operatorLen=0;          //����������
	var tmpLen=0;
	var objOption=null;       //����������
	
	for(num=0; num<operatorArrLen; num++){
		objOperator=operatorObjArr[num];
		operatorIndex=objOperator.index;
		tmpLen=operatorIndex-curretnIndex;    //����������ĳ���
		if(tmpLen>0){
			objOption=new Object();
			objOption.index=curretnIndex;                           //����λ��
			objOption.name=exption.substr(curretnIndex, tmpLen);    //�����������������������
			objOption.type="0";                                     //������
			expObjLen=expObjArr.push(objOption);
			optionsLen=optionsLen+1;
		}
		expObjLen=expObjArr.push(objOperator);
		operatorLen=objOperator.name.length;       //����������
		curretnIndex=operatorIndex+operatorLen;    //��ǰ����
	}
	
	//if(curretnIndex<(exption.length-1)){    //������һλ�ǲ��������ҳ���Ϊ1������������=��ʽ����-1
	if(curretnIndex<(exption.length)){
		objOption=new Object();
		objOption.index=curretnIndex;                           //����λ��
		objOption.name=exption.substr(curretnIndex);            //�����������������������
		objOption.type="0";                                     //������
		expObjLen=expObjArr.push(objOption);
		optionsLen=optionsLen+1;
	}
	
	if(optionsLen==0){
		$.messager.alert("��ʾ","��ʽ��û�о���Ĺ���(������)") ;
		return false;
	}
	
	//03 �жϱ��ʽ��ÿһ��Ԫ���Ƿ�Ϸ�
	var beforIndex, nextIndex;     //ǰһ��Ԫ�ص���������һ��Ԫ�ص�����
	var objBefor, objNext;
	var tmpObjExp =null;
	var name="";
	var type="";    //0:������ 1������� 2������
	
	var expObjArrLen=expObjArr.length;
	//alert("expObjArr.length="+expObjArr.length);
	for(iNum=0; iNum<expObjArrLen; iNum++){
		tmpObjExp=expObjArr[iNum];
		type=tmpObjExp.type;
		name=tmpObjExp.name;
		//alert("type="+type+"||name="+name);
		//03-01 ���ʽ��ʼԪ�صĺϷ����ж�
		if(iNum==0){
			//ֻ���Բ�������"'"����"("��ʼ���ʽ
			if(((type=="0")||((type=="1")&&(name=="'"))||((type=="2")&&(name=="(")))==false){
				$.messager.alert("��ʾ","��ʽ�в�����["+name+"]��ͷ") ;
				return false;
			}
		}
		
		//03-02 ���ʽ��β�Ϸ�����֤
		if(iNum==(expObjArrLen-1)){
			// ֻ���Բ���������")"��β
			if(((type=="0")||((type=="2")&&(name==")")))==false){
				$.messager.alert("��ʾ","��ʽ�в�����["+name+"]��β") ;
				return false;
			}
		}
		
		//03-03 ���ʽ���������֤
		if(type=="1"){
			beforIndex=iNum-1;    //ǰһ��Ԫ�ص�����
			nextIndex=iNum+1;     //��һ��Ԫ�ص�����
			if(nextIndex>=expObjArrLen){
				nextIndex=-1;    //û�к�һ��Ԫ��
			}
			
			//��Ŀ����������������������ǰһ��Ԫ�ر���Ϊ������
			if(beforIndex>-1){
				objBefor=expObjArr[beforIndex];
				//��Ŀ�����ǰ�߲���ֱ�Ӹ��������պ����ŵ�
				if((name=="'")&&((objBefor.name==")")||(objBefor.type=="0"))){
					$.messager.alert("��ʾ","�����["+name+"]��ǰһ��Ԫ�ز���Ϊ["+")]") ;
					return false;
				}
				
				//˫Ŀ�����ǰ�߱���Ϊ���������߱պ�
				if((name!="'")&&(objBefor.type!="0")&&(objBefor.name!=")")){
					$.messager.alert("��ʾ","�����["+name+"]��ǰһ��Ԫ�ز��ǲ�����") ;
					return false;
				}
			}
			
			//������ĺ�һ��Ԫ�ر���Ϊ������
			if(nextIndex>-1){
				objNext=expObjArr[nextIndex];
				if((objNext.type!="0")&&(objNext.name!="(")&&(objNext.name!="'")){
					$.messager.alert("��ʾ","�����["+name+"]�ĺ�һ��Ԫ�ز��ǲ�����") ;
					return false;
				}
			}
		}
	}
	
	return true;
}


///******************************************************************
///����˵����
///          ���ò������
///******************************************************************
function setLayOut(){

	///���Ӳ���ҳ��Ĳ��Թؼ��������
	$('#strategykeySearchmain').searchbox({
		prompt : '�������عؼ������',
		searcher : function (value, name) {
			StrategyAddFunction('1');
		}
	});
	
	$('#strategykeySearch').searchbox({
		prompt : '�������عؼ��ֲ�ѯ',
		searcher : function (value, name) {
		reloadAddStrategyGV('load');
		}
	});

	
	setDictionaryGV();
	
	setDictionaryInfo();
	//������ϸ׷��
	setAddDictionary();
	
	
	
	
	$('#keywordIn').searchbox({
		prompt : '������ؼ���',
		searcher : function (value, name) {
			reloadDictionaryGV('load');
		}
	});

	/*
	$("#DataFromFactor").combobox({
		valueField:"code",
		textField:"desc",
		data:[{
			"code":"0",
			"desc":"��������"
		},{
			"code":"1",
			"desc":"�̶�ֵ",
			"selected":true
		},{
			"code":"2",
			"desc":"��������"
		}]
	});
	*/
	
	
	$("#ProActiveFlg").combobox({
		valueField:'value',
		textField:'text',
		data:[{
			'value':'1',
			'text':'��Ч',
			'selected':true
		},{
			'value':'0',
			'text':'��Ч'
		}]
	});
			
	$("#FDetaiActiveFlg").combobox({
		valueField:'value',
		textField:'text',
		data:[{
			'value':'1',
			'text':'��Ч',
			'selected':true
		},{
			'value':'0',
			'text':'��Ч'
		}]
	});

	//���õ����ñ�־
	$("#ConfigActiveFlg").combobox({
		valueField:'value',
		textField:'text',
		data:[{
			'value':'1',
			'text':'����'
		},{
			'value':'0',
			'text':'δ����'
			,'selected':true
		}]
	});
		
	$HUI.combobox('#HospitalNo',{
		url: $URL,
		valueField: 'code',
		textField: 'desc',
		//panelHeight:150,
		mode:'remote',
		onBeforeLoad:function(param){
			param.ClassName="INSU.BL.QueryFactorDetail";
			param.QueryName="SearchHOSPList";
			param.ResultSetType="array";
			param.InputPam=" ";
		}
	});
	
	setEditCommonArea();   //��ע��Ϣ�༭
}

///+dongkf 2017 04 27 ���ʽʹ�ó�����չ�������� ��ʼ==========================================
/// ����˵�������ñ��ʽʹ�ó�������չ����������
function setExpUseAdmType(){
	var ExpUserTypeArr=[];
	var index=-1;
	var tmpObj=null;
	
	var baseLen=StrategyUseOption.length;
	for(i=0;i<baseLen;i++){
		tmpObj=StrategyUseOption[i];
		index=index+1;
		ExpUserTypeArr[index] = new Object();
		ExpUserTypeArr[index].code=tmpObj.code;
		ExpUserTypeArr[index].desc=tmpObj.desc;
		if("selected" in tmpObj){
			ExpUserTypeArr[index].selected=tmpObj.selected;
		}
	}
	
	var dicType="DIC_Express_UserType";
	var url=APP_PATH+"/com.INSUQCDicDataCtl/dicTypeList";
	var data={
		dicType:dicType
	};
	///��ȡҽ������
	$.post(url,data,function(data){
		$("#InsuTypeArea").empty();
		var dataNums=data.length;
		if(dataNums>0){
			for(j=0; j<dataNums; j++){
				tmpObj=data[j];
				index=index+1;
				ExpUserTypeArr[index] = new Object();
				ExpUserTypeArr[index].code=tmpObj.DicCode;
				ExpUserTypeArr[index].desc=tmpObj.DicDesc;
			}
		}
		
		setExpUseAdmTypeDo(ExpUserTypeArr);    //��������������
	},"json") ;
}

function setExpUseAdmTypeDo(ExpUserTypeArr){
	$('#UseAdmType').combobox({
		valueField:'code',
		textField:'desc',
		data:ExpUserTypeArr
		,onSelect:function(record){
			ReSetEidtformul();           //���ʽ����
			LoadStrategySubList();       //���Բ���������
		}
	});
}
///+dongkf 2017 04 27 ���ʽʹ�ó�����չ�������� ����==========================================

//+dongkf 2016 03 15 start
function setFindByCateInfo(hospitalNo,insuType){
	//ֻȡ��Ч���
	var url=APP_PATH+"/dic.INSUQCDicStrategyCateCtl/FindByComboboxListAjax&hospitalNo="+hospitalNo+"&insuType="+insuType;
	$.get(url,function(data){
		$('#FindByCate').combobox('clear');
		$('#FindByCate').combobox('loadData',data.data);                    //��ҳ���ϵĲ��Դ����
		$('#FindByCateSearch').combobox('clear');
		$('#FindByCateSearch').combobox('loadData',data.data);         //���Ӳ��Թ���ҳ���ϵĲ��Դ����
		if(data.data.length>0){
			$('#FindByCate').combobox('setValue',data.data[0].value) ;
			$('#FindByCateSearch').combobox('setValue',data.data[0].value) ;
			//alert("first") ;
			//SubCateonSelect(data.data[0]) ;
		}
	},"json") ; 
	
}

function SetFindBySubCateCombobox(CateCode, AddPageFlg)
{
	//alert("CateCode="+CateCode+"||AutoLoad="+AutoLoad);
	var hospitalNo=$("#hospitalNo").val();
	var insuType=$("#insuType").val();
	var url=APP_PATH+"/dic.INSUQCDicStrategyCateCtl/FindbyCateAndSubListAjax&CheckActive=0&hospitalNo="+hospitalNo+"&insuType="+insuType;
	$.get(url,function(data){
		SubFindByCateList=data ;
		var Len=SubFindByCateList.length ;
		var Data ;
		var DataList=new Array() ;
		var TmpList;
		for(var i=0; i < Len ;i++)
		{
			Data=SubFindByCateList[i] ;
			TmpList=Data.ShowValue.split("^") ;
			if(TmpList[0] == CateCode)
			{
				DataList.push(Data) ;
			}
		}
		
		var SubCateID="#FindBySubCate";
		if(AddPageFlg=="1"){
			SubCateID="#FindBySubCateSearch";
		}
		
		$(SubCateID).combobox('clear');
		$(SubCateID).combobox('loadData',DataList);
		if(DataList.length>0)
		{
			/*
			if((typeof AutoLoad!="undefined")&&(AutoLoad=="0")){
				$('#FindBySubCate').combobox("setValue","ȫ������") ;
			}else{
				$('#FindBySubCate').combobox("setValue",DataList[0].SubCate) ;
			}*/
			$(SubCateID).combobox("setValue",DataList[0].SubCate) ;
		}
	},"json") ;
}
//+dongkf 2016 03 15 end

///******************************************************************
///����˵����
///          ����������
///******************************************************************
function setProGressBar(){
	//���������ڵĴ�������
	$('#proWin').window({
		title:'�������...',
		width:400,
		height:60,
		modal:true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		onClose:function(){
			$('#progress').progressbar('setValue',0);
		}
	});
	
	//����������
	$('#progress').progressbar({
		width:386,
		height:24,
		value:0,
		onChange:function(newValue,oldValue){
			if(newValue>=100){  //������ɺ�رս�����
				$('#proWin').window('close');
			}
		}
	});
	
	$('#proWin').window('close');
}


var FactorEditIndex = undefined ;    //�����б�ǰ�༭�������

var DataFromArray = [{
						"code":"0",
						"desc":"��������"
					},{
						"code":"1",
						"desc":"�̶�ֵ"
					},{
						"code":"2",
						"desc":"��������"
					}];

var AuditFlgOption = [{
						"code":"0",
						"desc":"δ���"
					},{
						"code":"1",
						"desc":"�����"
					},{
						"code":"2",
						"desc":"�Ѿܾ�"
					}];
var TimeFn = null;
var TimeFactorDicFn=null;
						
function setDictionaryInfo(){
	$('#StrategyGV').datagrid({
		url:$URL,
		pagination:true,
		//fitColumns:'true',
		fit:true,
		pageSize:'10',
		pageList:[10,20,30],
		singleSelect:true,      
		//singleSelect:false,       //+dongkf 2019 12 03  ����checkbox �����֧�ֶ�ѡ
		striped:true,
		//rownumbers:true,
		toolbar:[],
		columns:[[
			//{field:"Check",checkbox:true},
			{field:'HospitalNo',title:'hospitalNo',hidden:'true'},
			{field:'InsuType',title:'insuType',hidden:'true'},
			{field:'RowID',title:'subRowid',hidden:'true'},
			{field:'UpdateUser',title:'user',hidden:'true'}, 
			{field:'ConDataDr',title:'ConDataDr',hidden:'true'},
			{field:'StrategyLevel',title:'StrategyLevel',hidden:'true'},
			{field:'FactorCode',title:'�������',width:70,hidden:'true'},
			{field:'FactorDesc',title:'���ط���',width:80},
			{field:'FactorName',title:'��������',width:150,editor:{type:'text'}
				,styler: function(value,row,index){
					var rtnStyle="";
					if(row.AuditFlg=="1"){
						rtnStyle= 'background-color:#00ffff;';
					}
					return rtnStyle;
				}
			},
			
			{field:'DataFrom',title:'������Դ',width:140,
				editor:{
					type:"combobox",
					options:{
						valueField:'code',
						textField:'desc',
						data:DataFromArray
					}
				},
				formatter:function(value,row){
					var rtn = "";
					rtn = getArrDescByCode(value,DataFromArray)
					return rtn;
				}
			},			
			{field:'CompareVal',title:'�̶�ֵ',width:145,editor:{type:'combobox'}},
			{field:'CompareNM',title:'�̶�ֵ����',width:105},
			{field:'CompareStartVal',title:'��Сֵ',width:80,editor:{type:'text'}},
			{field:'CompareEndVal',title:'���ֵ',width:80,editor:{type:'text'}},
			{field:'AuditFlg',title:'��˱��',width:90
				,editor:{
					type:'combobox',
					options:{
						valueField:'code',
						textField:'desc',
						data: AuditFlgOption
					}
				},
				formatter:function(value,row){
				 	var rtn=getArrDescByCode(value,AuditFlgOption);
				 	return rtn;
				}
			},
			{field:'InputPamTag',title:'��α��',width:130
				,formatter:function(value,row){
					var rtn="";
				 	var TagName=value;
					if(TagName==""){
						TagName=row.FactorCode
					}
					
				 	if(TagName !=""){
				 		rtn="&lt;"+TagName+"&gt;";
				 	}
				 	
				 	return rtn;
				}
			}
			,{field:'FactorCommon',title:'���ر�ע',width:200}
			,{field:'CheckClsName',title:'��֤����',width:150,hidden:'true'}
			,{field:'CheckMethodName',title:'��֤������',width:150,hidden:'true'}
			
			
			,{field:'XStr1',title:'query�������ݼ���־',width:150,hidden:'true'}
			,{field:'XStr2',title:'��֤����',width:150,hidden:'true'}
			,{field:'XStr3',title:'��֤����',width:150,hidden:'true'}
		]]
		
		
		,onLoadSuccess:function(data){
			      //��ѡ����ѡ��״̬         -dongkf 2019 12 03
			SetRowCheckedByAuditFlg("StrategyGV");    //�����ύ�޸�Ϊѡ���ȫ���ύ   +dongkf 2019 12 03
			if(data.rows.length>0){
				ReSetEidtformul();
				
				LoadStrategySubList();       //���Բ���������
			}
			
			BuildConfigPamFormat();    //��֯��֤��θ�ʽ
		}
		,onClickRow:function(rowIndex,rowData){
			//alert("RowID="+rowData.RowID+"||ConDataDr="+rowData.ConDataDr);
			clearTimeout(TimeFn);      ///������ʱ�����ڽ������¼���˫���¼����ֿ�
			TimeFn = setTimeout(function () {
				$("#StrategyGV").datagrid("beginEdit",rowIndex);
				
				if((FactorEditIndex!=undefined)&&(FactorEditIndex!=rowIndex)){
					$("#StrategyGV").datagrid("endEdit",FactorEditIndex);
				}
				
				var edmin=$('#StrategyGV').datagrid("getEditor",{'index':rowIndex,field:"CompareStartVal"}) ;         //��Сֵ��Ԫ��༭����
				var edmax=$("#StrategyGV").datagrid('getEditor', { 'index': rowIndex, field: 'CompareEndVal' });    //���ֵ��Ԫ��༭����
				var edvalue=$("#StrategyGV").datagrid('getEditor', { 'index': rowIndex, field: 'CompareVal' });     //�̶�ֵ��Ԫ��༭����
				
				
				///alert("query��ǣ�"+rowData.XStr1);
				//if(rowData.XStr1=="1"){
					var className = rowData.XStr2;
					var QueryName = rowData.XStr3;
					$(edvalue.target).combobox({
						url: $URL,
						valueField: 'code',
						textField: 'desc',
						//panelHeight:150,
						mode:'remote',
						onBeforeLoad:function(param){
							param.ClassName=className;
							param.QueryName=QueryName;
							param.ResultSetType="array";
							param.InputPam=$(edvalue.target).combobox("getValue")+"^"+rowData.RowID;
						}
						,onSelect:function(record){
							rowData.CompareNM=record.desc;
							$("#StrategyGV").datagrid('endEdit',FactorEditIndex)
							//console.log(rowData);
							$("#StrategyGV").datagrid('updateRow',{
								index: FactorEditIndex,
								row:rowData
							});
							$("#StrategyGV").datagrid('beginEdit',FactorEditIndex)
							//$("#StrategyGV").datagrid('refreshRow', FactorEditIndex);
							
						}
					});
				//}
				
				//$(edmax.target).attr("disabled", true);							
				//$(edmin.target).attr("disabled", true);
				//$(edvalue.target).combobox({disabled:true});
				
				
				var cd=$("#StrategyGV").datagrid('getEditor',{'index':rowIndex,field:'DataFrom'});
				if(cd){					
					//$(cd.target).combobox('setValue',rowData.DataFrom);
					//alert(rowData.DataFrom);
					$(cd.target).combobox({
						onSelect:function(record){
							var DataFrom = record.code;
							SetRowEditStatus(DataFrom, edmax, edmin, edvalue, rowData);    //���ñ༭״̬
							//alert(DataFrom)
							/*
							if(DataFrom=="1"){    //������ԴΪ�̶�ֵ�����������ò��ܱ༭							
								$(edmax.target).attr("disabled", true);							
								$(edmin.target).attr("disabled", true);
								$(edvalue.target).combobox({disabled:false});
							}else if(DataFrom=="2"){
								$(edmax.target).attr("disabled", false);
								$(edmin.target).attr("disabled", false);
								$(edvalue.target).combobox({disabled:true});
							}else{
								$(edmax.target).attr("disabled", true);
								$(edmin.target).attr("disabled", true);
								$(edvalue.target).combobox({disabled:true});
							}
							*/
						}
						,onLoadSuccess:function(){
							$(this).combobox('setValue',rowData.DataFrom);
							SetRowEditStatus(rowData.DataFrom, edmax, edmin, edvalue, rowData);    //���ñ༭״̬
						}
					})
				}
				
				FactorEditIndex = rowIndex;
			
			}, 200);
		},
		onDblClickRow:function(rowIndex,rowData){
			clearTimeout(TimeFn);
			$('#StrategyGV').datagrid('endEdit',rowIndex);
			//��ʼ��������ϸ����
			$('#CofingFactorDr').val("");
			$('#queryflg').val("");
			$('#ProCode').val("");
			$('#ProName').val("");
			$('#ProValue').val("");
			$('#ProActiveFlg').combobox('setValue', "1");
			
			var DataFrom = rowData.DataFrom;     //������Դ  0 ���ݼ�  1 �̶�ֵ  2 ��������
			if(DataFrom=="0"){           //���ݼ��ڵ������޸�
				$("#CofingFactorDr").val(rowData.ConDataDr)
				var queryflg=rowData.XStr1;   //query ��ѯ���
				var className=rowData.XStr2;   //query����
				var QueryName=rowData.XStr3;  //query������
				if((queryflg=="1")&&(className!="")&&(QueryName!="")){
					$("#ProCode").hide();        //�����query��ѯ�����ݣ�����ʾ����������������ѡ����Ҫά�������ݣ��������ı������ֹ���������
					$("#ProCodeCombo").show();
					
					$('#ProCodeCombo').css('display','none');
					$("#queryflg").val("1");    //query��ѯ���ݱ��
					$HUI.combobox('#ProCodeCombo',{
						url: $URL,
						valueField: 'code',
						textField: 'desc',
						panelHeight:150,
						mode:'remote',
						onBeforeLoad:function(param){
							param.ClassName=className;
							param.QueryName=QueryName;
							param.ResultSetType="array";
							param.InputPam=$(this).combobox("getValue")+"^"+rowData.RowID;
						},
						onSelect:function(record){
							$(this).combobox("setText",record.code);
							$("#ProName").val(record.desc);
						}
					});
					$('#ProCodeCombo').combobox('clear');
					$('#ProCodeCombo').combobox('loadData', []);
					//$HUI.combobox('#ProCodeCombo','clear');    //���
				}else{
					$("#ProCode").show();        //�����query��ѯ�����ݣ�����ʾ����������������ѡ����Ҫά�������ݣ��������ı������ֹ���������
					$("#ProCodeCombo").hide();
					$("#queryflg").val("0");
				}
				
				$('#Edit_ConfigMap_Area').window("open");
			}
			/*
			else{           //�̶�ֵ����������ֱ���ڲ����б༭
				if((FactorEditIndex!=undefined)&&(FactorEditIndex!=rowIndex)){
					$("#StrategyGV").datagrid("endEdit",FactorEditIndex);
				}
				$("#StrategyGV").datagrid("beginEdit",rowIndex);
				if(DataFrom=="1"){    //������ԴΪ�̶�ֵ�����������ò��ܱ༭
					var edmax=$('#StrategyGV').datagrid("getEditor",{index:rowIndex,field:"CompareStartVal"}) ;
					$(edmax.target).attr("disabled", true);
					var edmin=$("#StrategyGV").datagrid('getEditor', { 'index': rowIndex, field: 'CompareEndVal' });
					$(edmin.target).attr("disabled", true);
				}
				if(DataFrom=="2"){
					var edvalue=$("#StrategyGV").datagrid('getEditor', { 'index': rowIndex, field: 'CompareVal' });
					$(edvalue.target).attr("disabled", true);
				}
				FactorEditIndex = rowIndex;
			}
			*/
		}
		,loadFilter: function(data){
			if("status" in data)
			{
				if(data.status<0)
				{
					$.messager.alert("��ʾ","��������������"+data.info) ;
				}
			}
			if(!("rows" in data)){
				data.rows=[] ;
			}
			if(!("total" in data)){
				data.total=0 ;
			}
			return data;
		}

	});
	
	/// ���Ӳ���ҳ��Ĳ���չʾ�б�
	$('#AddStrategyGV').datagrid({
		//title: '֪ʶ�������ϸ',
		//url:APP_PATH+"/base.MedicalKeywordCtl/SearchMedicalKeyAjax",
		pagination:true,
		//fitColumns:'true',
		fit:true,
		pageSize:'10',
		pageList:[10,20,30],
		singleSelect:true,
		striped:true,
		selectOnCheck:false,
		checkOnSelect:false,
		toolbar:[],
		columns:[
			[
			{field:"Check",checkbox:true},
			{field:'RowID',title:'subRowid',hidden:'true'},
			{field:'FactorCode',title:'���ر���',width:115,sortable:'true'},
			{field:'FactorDesc',title:'��������',width:120},
			{field:'InputPamTag',title:'��α��',width:130
				,formatter:function(value,row){
					var rtn="";
				 	var TagName=value;
					if(TagName==""){
						TagName=row.FactorCode
					}
					
				 	if(TagName !=""){
				 		rtn="&lt;"+TagName+"&gt;";
				 	}
				 	
				 	return rtn;
				}
			},
			{field:'EditFlg',title:'˫���༭',width:85
				,formatter:function(value,row){
				 	var rtn="";
				 	var EditFlg="0";
					var queryFlg=row.XStr1;
					var queryCls=row.XStr2;
					var queryName=row.XStr3;
					//alert("queryFlg="+queryFlg+"|queryCls="+queryCls+"|queryName="+queryName);
					if((queryFlg=="1")&&(queryCls=="INSU.BL.QueryFactorDetail")&&(queryName=="SearchFactorListCom")){
						EditFlg="1";
					}
				 	
				 	if(EditFlg=="1"){
				 		rtn="��˫��";
				 	}else{
				 		rtn="";
				 	}
				 	return rtn;
				}
			},
			//{field:'DataFrom',title:'������Դ',width:100,hidden:'true'},
			{field:'XStr1',title:'query���ɱ��',width:100,
				formatter:function(value,row){
				 	var rtn="";
				 	if(value=="1"){
				 		rtn="��";
				 	}else{
				 		rtn="��";
				 	}
				 	return rtn;
				}
			},
			{field:'XStr2',title:'query����',width:200},
			{field:'XStr3',title:'query������',width:150},
			{field:'FactorCommon',title:'���ر�ע',width:120},
			{field:'CheckClsName',title:'��֤����',width:100},
			{field:'CheckMethodName',title:'��֤������',width:100}
			]
		],
		onClickRow:function(index, rowData){
			clearTimeout(TimeFactorDicFn);      ///������ʱ�����ڽ������¼���˫���¼����ֿ�
			TimeFactorDicFn = setTimeout(function () {
				var Flag=$('#AddStrategyGV').parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(':checked');
				if(Flag){
					$('#AddStrategyGV').datagrid('uncheckRow',index);
					$(this).datagrid('unselectRow', index); 
				}else{
					$('#AddStrategyGV').datagrid('checkRow',index);
					$(this).datagrid('selectRow', index); 
					$('#AddStrategyGV').parent().find(".datagrid-body .datagrid-btable tbody").children("tr").eq(index).addClass("SelectedRowRecStyle");     //���õ�ǰ�еĸ�����ʾ
					
				}
			}, 200);
		},
		onDblClickRow:function(rowIndex,rowData){
			var queryFlg=rowData.XStr1;
			var queryCls=rowData.XStr2;
			var queryName=rowData.XStr3;
			//alert("queryFlg="+queryFlg+"|queryCls="+queryCls+"|queryName="+queryName);
			if((queryFlg=="1")&&(queryCls=="INSU.BL.QueryFactorDetail")&&(queryName=="SearchFactorListCom")){
				clearTimeout(TimeFactorDicFn);
				$("#FactorDicDr").val(rowData.RowID);
				clearFactorDicDetailEdit();   //��ձ༭����
				//alert("rowData.RowID="+rowData.RowID);
				$("#FactorDic_Details_Area").window("open");
			}
		},
		onLoadSuccess:function(data){
			//������ɺ�ѡ�е����õ������Ԫ��Ĭ�Ϲ�ѡ
			/*
			var SelFactorRows=$("#StrategyGV").datagrid("getRows");
			var data=$("#AddStrategyGV").datagrid("getRows");			
			for(var index=0;index<data.length;index++){      //����Ԫ��
				var Factor=data[index];
				var FactorCode=Factor.FactorCode;    //Ԫ���б�				
				for(var Selindex=0;Selindex<SelFactorRows.length;Selindex++){     //���õ������Ԫ��
					var SelRow=SelFactorRows[Selindex];
					var LinkFactorCode=SelRow.FactorCode;					
					if(FactorCode==LinkFactorCode){
						var FactorIndex=$("#AddStrategyGV").datagrid("getRowIndex",Factor);						
						$('#AddStrategyGV').datagrid('checkRow',FactorIndex);
					}
				}
			}
			*/
		}
	});
	
	
	$("#ConfigFacDetailGV").datagrid({
		pagination:true,
		fit:true,
		pageSize:'10',
		pageList:[10,20,30],
		singleSelect:true,
		striped:true,
		toolbar:[],
		columns:[
			[
			{field:'RowID',title:'RowID',hidden:'true'},
			{field:'CofingFactorDr',title:'CofingFactorDr',hidden:'true'},
			{field:'ProCode',title:'����Ԫ�ر���',width:100},
			{field:'ProName',title:'����Ԫ������',width:160},
			{field:'ProValue',title:'����Ԫ�ؿ�ѡֵ',width:120},
			{field:'ActiveFlg',title:'��Ч���',width:100
				,formatter:function(value,row){
					var rtn="";
					if(value=="1"){
						rtn="��Ч";
					}else{
						rtn="��Ч";
					}
					return rtn;
				}
			},
			{field:'UpdateUser',title:'����Ա',width:100},
			{field:'UpdateDate',title:'��������',width:100},
			{field:'UpdateTime',title:'����ʱ��',width:100}
			]
		],
		onClickRow:function(rowIndex,rowData){
			setEditConfig(rowData);
		}
	});
	
	//Ӱ�����ؿ�ѡֵ��Χά��
	$("#FactorDicDetailGV").datagrid({
		pagination:true,
		fit:true,
		pageSize:'10',
		pageList:[10,20,30],
		singleSelect:true,
		striped:true,
		toolbar:[],
		columns:[
			[
			{field:'RowID',title:'RowID',hidden:'true'},
			{field:'FactorDr',title:'FactorDr',hidden:'true'},
			{field:'ProCode',title:'��ѡֵ����',width:100},
			{field:'ProName',title:'��ѡֵ����',width:160},
			{field:'ProValue',title:'��ѡֵ',width:120},
			{field:'ActiveFlg',title:'��Ч���',width:100
				,formatter:function(value,row){
					var rtn="";
					if(value=="1"){
						rtn="��Ч";
					}else{
						rtn="��Ч";
					}
					return rtn;
				}
			},
			{field:'UpdateUser',title:'����Ա',width:100},
			{field:'UpdateDate',title:'��������',width:100},
			{field:'UpdateTime',title:'����ʱ��',width:100},
			{field:'FactorCode',title:'���ر���',width:100},
			{field:'FactorDesc',title:'��������',width:100}
			]
		],
		onClickRow:function(rowIndex,rowData){
			setFactorDicDetailEdit(rowData);
		}
	});
}


function setFactorDicDetailEdit(rowData){
	$('#FactorDetailDr').val(rowData.RowID);
	$('#FDetailCode').val(rowData.ProCode);
	$('#FDetailName').val(rowData.ProName);
	$('#FDetaiValue').val(rowData.ProValue);
	$('#FDetaiActiveFlg').combobox('setValue', rowData.ActiveFlg);
}

/// ���Ӱ�����ر༭ҳ��ı༭����ֵ
function clearFactorDicDetailEdit(){
	$('#FactorDetailDr').val("");
	$('#FDetailCode').val("");
	$('#FDetailName').val("");
	$('#FDetaiValue').val("");
	$('#FDetaiActiveFlg').combobox('setValue', '1');
}

function SetRowEditStatus(DataFrom, edmax, edmin, edvalue, rowData){
	if(DataFrom=="1"){    //������ԴΪ�̶�ֵ�����������ò��ܱ༭							
		$(edmax.target).attr("disabled", true);							
		$(edmin.target).attr("disabled", true);
		$(edvalue.target).combobox({disabled:false});
		$(edvalue.target).combobox('setValue',rowData.CompareVal);
	}else if(DataFrom=="2"){
		$(edmax.target).attr("disabled", false);
		$(edmin.target).attr("disabled", false);
		$(edvalue.target).combobox({disabled:true});
	}else{
		$(edmax.target).attr("disabled", true);
		$(edmin.target).attr("disabled", true);
		$(edvalue.target).combobox({disabled:true});
	}
}

//�������õ��������� ��֤��Ҫ��xml������ʽ
function BuildConfigPamFormat(){
	$("#inputPamInfo").html("") ;    //���ԭ���Ĺ�ʽ
		
	var Data=$('#StrategyGV').datagrid("getData") ;
	if("rows" in Data){
		DataRows=Data.rows;
	}else{
		return ;
	}
	
	var PamNodes="";
	var Len=DataRows.length ;
	if(Len>0){
		var AuditFlg="0";
		var PamNode="";
		var FactorCode="";         //�����ֵ����
		var FactorDesc="";         //�����ֵ�����
		var InputPamTag="";     //��α��
		var NodeTagArr=[];
			
		for(var i=0 ; i < Len ; i++ )
		{
			var Data=DataRows[i] ;
			AuditFlg=Data.AuditFlg;     //��˱��
			if(AuditFlg !="1") { continue; }
			FactorCode=Data.FactorCode;
			FactorDesc=Data.FactorDesc;
			InputPamTag=Data.InputPamTag;
			if(InputPamTag==""){
				InputPamTag=FactorCode;
			}
			if(NodeTagArr.indexOf(InputPamTag) != -1){   //�Ѿ����ڵĳ��� ����
				continue;
			}
			
			PamNode="<"+InputPamTag+">"+FactorDesc+"</"+InputPamTag+">";    //���쵥�����ص�
			if(PamNodes==""){
				PamNodes=PamNode;
			}else{
				PamNodes=PamNodes+PamNode;
			}
			NodeTagArr.push(InputPamTag);    //�Ѿ����ɹ��Ĳ��� ���뵽������
		}
	}

	var ConfigNode="<ConfigCode>ҵ�����õ�</ConfigCode>";
	var InputPamInfo="<Input>"+ConfigNode+PamNodes+"</Input>";
	$("#inputPamInfo").text(InputPamInfo);
}

/// ����˵�����������״̬���õ�ǰ
function SetRowCheckedByAuditFlg(StrategyGV){
	var objRow=null;
	var AuditFlg="0";
	var rowRecs=$('#'+StrategyGV).datagrid('getRows');
	var rowLen=rowRecs.length;                             //������
	for (i=0; i<rowLen; i++){
		objRow=rowRecs[i];        //��ǰ������
		AuditFlg=objRow.AuditFlg;        //����˱��
		if(AuditFlg=="1"){
			$('#'+StrategyGV).datagrid('checkRow', i);
		}else{
			$('#'+StrategyGV).datagrid('uncheckRow', i);
		}
	}
}

///******************************************************************
///����˵����
///          ʹ��˸�ѡ���ڿɱ༭״̬,��ע���¼�
///******************************************************************
function setStrateEditStatis(EditFlg){
	var rowRecs=$('#StrategyGV').datagrid('getRows');
	var rowLen=rowRecs.length;                             //������
	for (i=0;i<rowLen;i++){
		if(EditFlg=="1"){
			$('#StrategyGV').datagrid('beginEdit', i);
			var $editOpt=$('#StrategyGV').datagrid('getEditor', {index:i,field:'AuditFlg'});
			$editOpt.target.on("click",function(e){
				SingeStrateAuditCheckClick(e);
			});
			
		}else{
			$('#StrategyGV').datagrid('endEdit', i);
		}
	}
}

/// ��˸�ѡ�����¼�
function SingeStrateAuditCheckClick(e){
	var AuditTarget=e.target;
	var RowIndex=$(AuditTarget).parents(".datagrid-row").attr("datagrid-row-index");    //����������
	
	$('#StrategyGV').datagrid('endEdit', RowIndex);
	var DataRows=$('#StrategyGV').datagrid('getRows');     //��ǰҳ����������
	var RowData=DataRows[RowIndex];                              //��ǰ������
	//alert("RowIndex="+RowIndex);
	//UpdateCommonInfo(0, 1, RowData, "0")                       //���±�������
	UpdateStrategyInfo(RowIndex, 1, RowData, LgUserID,"0");     //�������
}

///******************************************************************
///����˵����
///          ����������ϸʱ������Ϊ�ɱ༭״̬
///******************************************************************
var editIndex=undefined;
function StrategyGVonClickRow(index, rowData){

	//���ñ༭��
	$(this).datagrid('beginEdit', index);
	var ed = $(this).datagrid('getEditor', {index:index,field:'AuditFlg'});
	$(ed.target).focus();
	var ed=$('#StrategyGV').datagrid("getEditor",{index:index,field:"ControlLevel"}) ;
	if(ed){
		$(ed.target).combobox("loadData",ControlLevel);
	}
	var ed=$('#StrategyGV').datagrid("getEditor",{index:index,field:"DetailLevel"}) ;
	if(ed){
		$(ed.target).combobox("loadData",StrategyArrLevel);
	}

	
	if((editIndex!=undefined)&&(editIndex!=index)){
		$(this).datagrid('endEdit', editIndex);
	}
	editIndex=index;
}

///******************************************************************
///����˵����
///          �������޸ĵ�������״̬��Ϊ�Ѿ��޸����
///******************************************************************
function endEditRow(){
	$("#StrategyGV").datagrid('endEdit', editIndex);
	editIndex = undefined;
}

///******************************************************************
///����˵����
///          ����֪ʶ��һ������
///******************************************************************
function setDictionaryGV(){
	$('#DictionaryGV').datagrid({
		fit:true,
		pagination:true,
		pageSize: 30,
		singleSelect:true,
		striped: true,
		toolbar: [],
		columns:[[
			{field:'ConfigCode',title:'���õ����',width:150},
			{field:'ConfigDesc',title:'���õ�����',width:200
				,styler: function(value,row,index){
					var rtnStyle="";
					if(row.ActiveFlg=="1"){
						rtnStyle= 'background-color:#00ffff;';
					}
					return rtnStyle;
				}
			},
			{field:'ActiveFlg',title:'���ñ�־',width:80
				,formatter:function(value,row){
					var rtn = "";
					if(value=="1"){
						rtn="����";
					}else{
						rtn="δ����";
					}
					
					return rtn;
				}
			},
			{field:'UpdateUser',title:'����Ա',width:100},
			{field:'UpdateDate',title:'��������',width:100},
			{field:'UpdateTime',title:'����ʱ��',width:100},
			{field:'ConfigCommon',title:'��ע',width:250},
			{field:'XStr1',title:'����1',width:150, hidden:true},
			{field:'XStr2',title:'����2',width:150, hidden:true},
			{field:'XStr3',title:'����3',width:150, hidden:true},
			{field:'XStr4',title:'����4',width:150, hidden:true},
			{field:'XStr5',title:'����5',width:150, hidden:true},
			{field:'RowID',title:'RowID',hidden:true}
		]],
		url: $URL,
		queryParams: {
			ClassName:"INSU.BL.ConfigPointCtl",
			QueryName:"SearchConfigPoint",
			InputPam: ""
		},
		onClickRow:function(index, rowData){
			var CollocationDr=rowData.RowID;
			$("#rowid").val(rowData.RowID);
			$('#StrategyGV').datagrid('load',{
				ClassName:"INSU.BL.ConfigPointCtl",
				QueryName:"SearchFactorsByConfig",
				InputPam:CollocationDr
			});
			
		},
		onLoadSuccess:function(data){
			DictionaryStrategyInfoClear();    //������ϸ�����ʼ��
			
			//setItmEditStatis("1");    //��ѡ����ѡ��״̬
			//SetRowCheckedByAuditFlg("DictionaryGV");    //�����ύ�޸�Ϊѡ���ȫ���ύ   +dongkf 2019 12 03
		}
		,loadFilter: function(data){
			if("status" in data)
			{
				if(data.status<0)
				{
					$.messager.alert("��ʾ","��������������"+data.info) ;
				}
			}
			if(!("rows" in data)){
				data.rows=[] ;
			}
			if(!("total" in data)){
				data.total=0 ;
			}
			return data;
		}
	});
}

var DicItmSelIndex=null;

///******************************************************************
///����˵����
///          ʹ��˸�ѡ���ڿɱ༭״̬,��ע���¼�
///******************************************************************
function setItmEditStatis(EditFlg){
	var rowRecs=$('#DictionaryGV').datagrid('getRows');
	var rowLen=rowRecs.length;                             //������
	for (i=0;i<rowLen;i++){
		if(EditFlg=="1"){
			$('#DictionaryGV').datagrid('beginEdit', i);
			var $editOpt=$('#DictionaryGV').datagrid('getEditor', {index:i,field:'AuditFlg'});
			$editOpt.target.on("click",function(e){
				SingerAuditCheckClick(e);
			});
			
		}else{
			$('#DictionaryGV').datagrid('endEdit', i);
		}
		/*
		var $editOpt=$(this).datagrid('getEditor', {index:i,field:'editopt'});
		$editOpt.target.on("click",function(e){
			checkBoxClick(e);
		});
		*/
	}
}

/// ��˸�ѡ�����¼�
function SingerAuditCheckClick(e){
	var AuditTarget=e.target;
	var RowIndex=$(AuditTarget).parents(".datagrid-row").attr("datagrid-row-index");    //����������
	
	$('#DictionaryGV').datagrid('endEdit', RowIndex);
	var DataRows=$('#DictionaryGV').datagrid('getRows');   //��ǰҳ����������
	var RowData=DataRows[RowIndex];                              //��ǰ������
	UpdateCommonInfo(0, 1, RowData, "0")                       //���±�������
}

/// ѡ��ע��
function SelectedCommonRow(index, rowData){
	DicItmSelIndex=index;
	setDictionaryDetail(index, rowData);   //����֪ʶ����ϸ��������
}

function FormulaClear(){
	
	//���ʽ�༭��Ϣ���
	$("#rowid").val();
	$("#StrategySubList").html("") ;
	$("#Eidtformul").html("") ;
	$("#ClearAll").click() ;
	$('#UseAdmType').combobox('setValue','C');
	$("input[name=FormulaType][value=2]").click();
	//$('#UseAdmType').val("")
	
	//endEditRow();                        //�༭״̬ȡ��
	//reloadStrategyGV('load');            //����ϸ�����
	
	
}

///******************************************************************
///����˵����
///          ��ѡ���֪ʶ���У����֪ʶ����ϸ���ݲ���
///******************************************************************
function setDictionaryDetail(index, rowData)
{

	$('#rowid').val(rowData.RowID);                 //ѡ�����ĿDr
	//$('#ItmCode').val(rowData.CommonCode);       //ѡ�����Ŀ����
	//$('#ItmDesc').val(rowData.CommonEdit);        //ѡ�����Ŀ����

	//reloadStrategyGV('load');  //������ϸ����
}


///******************************************************************
///����˵����
///          �¼�ע�᷽��
///******************************************************************
function regAllevent(){
	
	// ����һ��������ϸ
	$('#StrategyAdd').on('click',function(){
		StrategyAddFunction("0");
	});
	
	// ɾ��һ��������ϸ
	$('#StrategyRemove').on('click',StrategyRemoveFunction);
	
	// ���Ӳ�����ϸ��Ӧ���¼�
	regAddDictionaryEvent();
	
	//֪ʶ�����ݵ���(��) //+dongkf 2019 07 18
	$("#FactorImprot").on("click", function(){
		var UserDr=session['LOGON.USERID'];
		var GlobalDataFlg="0";                          	 //�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
		var ClassName="INSU.BL.ConfigPointCtl";                     //���봦������
		var MethodName="ImportConfigFactorByExcel";          //���봦������
		var ExtStrPam="";                                                        //���ò���()
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
	});
	
	/// ���뱸ע��Ϣ
	$("#CommonImprot").on("click", function(){
		var UserDr=session['LOGON.USERID'];
		var GlobalDataFlg="0";                          	 //�Ƿ񱣴浽��ʱglobal�ı�־ 1 ���浽��ʱglobal 0 ���浽����(�����������ͷ�����)
		var ClassName="INSU.BL.ConfigPointCtl";                     //���봦������
		var MethodName="ImportConfigPointByExcel";          //���봦������
		var ExtStrPam="";                                                        //���ò���()
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
	});
	
	///ά����ע��Ϣ 
	$("#open_edit_win").on("click", function(){
		$('#Edit_Common_Area').window("open");
	});
	
	$("#open_factor_edit_win").on("click", function(){
		$('#Edit_Factor_Area').window("open");
	});
	
	/// ��ձ༭����
	$("#ClearEdit").on("click", ClearCommonEditArea);
	
	/// ����������Ϣ
	$("#SaveCommon").on("click", SaveCommonInfo);
	
	//���������ֵ���Ϣ
	$("#SaveFactor").on("click", SaveDicFactorInfo);
	
	//ɾ�������ֵ���Ϣ
	$('#DeleteFactor').on("click", function(){
		var DataDr=$('#SelFactorDr').val();
		if(DataDr=="") { return 0;}
		$.messager.confirm("ɾ��", "ȷ��ɾ����������?", function (r) {
			if (r) {
				DeleteDicFactorInfo();
			} 
		});
	});
	
	//������ر༭����
	$("#ClearFactor").on("click",ClearFactorArea);
	
	// ɾ����ע��Ϣ
	$("#DeleteCommon").on("click", function(){
		var CommonDr=$('#SelCommonDr').val();
		if(CommonDr=="") { return 0;}
		$.messager.confirm("ɾ��", "ȷ��ɾ����������?", function (r) {
			if (r) {
				DeleteCommonInfo();
			} 
		});
	});
	
	
	///ɾ�����õ�����صĹ�����ϵ
	$("#DeletConFactorBtn").on("click", function(){
		if(CheckConfigActiveFlg()!="1"){    //�Ƿ���Ա༭��֤
			return 0;
		}
		
		var SelConFac = $("#StrategyGV").datagrid("getSelected");
		if(SelConFac==null){
			$.messager.alert("��ʾ","δѡ����Ҫɾ��������");
			return;
		}
		$.messager.confirm("ɾ��", "ȷ��ɾ����������?", function (r) {
			if (r) {
				DeletConFactor();
			} 
		});
	});
	
	///������������ύ
	$("#AuditChangeCommit").on("click",AuditChangeCommitFunction);
	
	///���������������ݼ�
	$("#addFacotrPro").on("click",SaveFactorConfigInfo);
	$("#FDetaiAddBtn").on("click",FDetaiAddBtnFun);
	
	$("#DelFactorPro").on("click",DeletFactorConfig);
	$("#FDetaiDelBtn").on("click",FDetaiDelBtnFun);
	$("#FDetaiClearBtn").on("click",function(){
		clearFactorDicDetailEdit();
	});
	
	/// ��ҳ ��ע��˴����¼�ע��
	$("#ItmCom_Audit_Btn").on("click", ItmCommonAudit);
	
	/// ��ҳ ��ע���ȡ��
	$("#ItmCom_AuditC_Btn").on("click", ItmCommonAuditC);
	
	// ���״̬�ı����Ŀ����ύ
	$("#ItmCom_AuditChange_Btn").on("click", ItmCommonAuditChange);
	
	///���ݼ��ֹ�ά����querey��ѯ���
	$("#queryflg").checkbox({
		onCheckChange:function(){
			if($(this).checkbox("getValue")){
				$("#queryInfoArea").show();
			}else{
				//$("#queryClass").val("");
				//$("#queryMethod").val("");
				$("#queryInfoArea").hide();
			}
		}
	})
	
}

	/// ��ҳ ��ע���ȡ��
function ItmCommonAuditC(){
	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#DictionaryGV').datagrid('getRows');                   //��ҳ��������
	var AllRowLen=AllrowRecs.length;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		if(objRowTmp.AuditFlg =="1"){
			rowRecs.push(objRowTmp);
		}
	}
	
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateCommonInfo(0, rowLen,rowRecs, "2");     //����ȡ����˱�ע��Ϣ
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'��ǰû����Ҫ�ύ�������Ϣ',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

/// ���״̬�޸ĵļ�¼����ύ
function ItmCommonAuditChange(){
	
	var CheckedIndexArr=GetCheckedRowIndexArr("DictionaryGV");    //ѡ���е���������
	
	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#DictionaryGV').datagrid('getRows');                   //��ҳ��������
	var AllRowLen=AllrowRecs.length;
	var AuditFlg="";
	var CheckedFlg=-1;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		AuditFlg=objRowTmp.AuditFlg;       //���״̬
		CheckedFlg=CheckedIndexArr.indexOf(index);          //��ǰ���Ƿ�ѡ��  ����Ϊ��ѡ��  ����Ϊѡ��
		if((AuditFlg=="1")&&(CheckedFlg<0)||(AuditFlg !="1")&&(CheckedFlg>=0)){    //ֻѡ���Ѿ��޸������״̬������
			rowRecs.push(objRowTmp);
		}
	}
	
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateCommonInfo(0, rowLen,rowRecs, "3");     //������˱�ע��Ϣ
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'��ǰû����Ҫ�ύ�������Ϣ',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

///��ע��˴����¼�ע��
function ItmCommonAudit(){

	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#DictionaryGV').datagrid('getRows');                   //��ҳ��������
	var AllRowLen=AllrowRecs.length;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		if(objRowTmp.AuditFlg !="1"){
			rowRecs.push(objRowTmp);
		}
	}
	
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateCommonInfo(0, rowLen,rowRecs, "1");     //������˱�ע��Ϣ
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'��ǰû����Ҫ�ύ�������Ϣ',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

// DoType --> 0 �������ݸ��� 1 ��ҳ���ͨ��
function UpdateCommonInfo(i, len, rowRecs, DoType){
	var objCommonInfo=null;
	if(DoType=="0"){     //��������
		objCommonInfo=rowRecs;
	}
	
	if((DoType=="1")||(DoType=="2")){    //��ҳ���ͨ�� �����Ƕ���
		objCommonInfo=rowRecs[i];
	}

	if(DoType=="3"){     //���״̬�ı����Ŀ����ύ
		objCommonInfo=rowRecs[i];
		var tmpAuditFlg=objCommonInfo.AuditFlg;      //��˱�־
		if(tmpAuditFlg=="1"){
			tmpAuditFlg="0";
		}else{
			tmpAuditFlg="1";
		}
		objCommonInfo.AuditFlg=tmpAuditFlg;      //��˱�־
	}
	
	var CommonDesc=objCommonInfo.CommonDesc;                       //������Ϣ����
	var CommonEdit=objCommonInfo.CommonEdit;                         //������Ϣ����
	var AuditFlg=objCommonInfo.AuditFlg;                                       //��˱�־
	if (DoType =="1" ) {  //��ҳ���ͨ��
		AuditFlg="1"; 
	}
	if(DoType=="2") {
		AuditFlg="0"; 
	}
	
	var RowDataInfo=CommonDesc+"^"+CommonEdit+"^"+AuditFlg;
	var CommonDr=objCommonInfo.RowID;                                      //������ϢDr
	var RowIndex=$('#DictionaryGV').datagrid('getRowIndex', objCommonInfo);       //ѡ�е�������
		
	//return 0;
	var Url=APP_PATH+"/base.CommonInfoCtl/SaveCommonAjax" ;
	$.post(
		Url,
		{
			RowDataInfo:RowDataInfo
			,UserDr:LgUserID
			,CommonDr:CommonDr
			,RowIndex:RowIndex
		},
		function(data,textStatus){
			if(textStatus=="success"){
				if(data.Status>0){
					/*
					var tmpIndex=data.RowIndex;
					if(tmpIndex !=""){
						$('#DictionaryGV').datagrid('updateRow', {
							index:tmpIndex
							,row:data.Data
						});
					}*/
					
					var index=i+1;
					if(index<len){     //�ж��Ƿ�������
						UpdateCommonInfo(index,len,rowRecs, DoType);
					}else{
						if((DoType=="1")||(DoType=="2")||(DoType=="3")){
							reloadDictionaryGV('reload');
							alert("������!");
						}else{ //������˹��� ����ҳ��
							var tmpIndex=data.RowIndex;
							if(tmpIndex !=""){
								$('#DictionaryGV').datagrid('updateRow', {
									index:tmpIndex
									,row:data.Data
								});
								$('#DictionaryGV').datagrid('beginEdit', tmpIndex);
							}
						}
					}

				}else{
					alert(data.info);
				}
			}else{
				$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
			}
		},
		'json'
	);
}

///ɾ�����õ���Ϣ
function DeleteCommonInfo(){
	var ConfigDr=$('#ConfigDr').val();
	var RowIndex=$('#ConfigIndex').val();
	
	//var Url=APP_PATH+"/base.CommonInfoCtl/DelCommonAjax" ;
	$cm(
		{
			ClassName:"INSU.BL.ConfigPointCtl",
			MethodName:"DeletConfigPoint",
			CollecationDr:ConfigDr
		},
		function(data){			
			if(parseInt(data.status)>0){
				
				reloadDictionaryGV('reload');   //���¼�������
				ClearCommonEditArea();         //��ձ༭����
				$.messager.show({
					title:'��ʾ',
					msg:'ɾ���ɹ�',
					timeout:2000,
					showType:'slide'
					,through:true
				});
			}else{
				$.messager.alert("������ʾ","ɾ��ʧ�ܣ�"+data.info);
			}
		},
		'json'
	);
}

/// ���汸ע������Ϣ
function SaveCommonInfo(){
	var ConfigCode=$('#ConfigCode').val();                       //������Ϣ����
	if(ConfigCode==""){
		alert("���õ���벻��Ϊ��");
		return 0;
	}
		
	var ConfigDesc=$('#ConfigDesc').val();                         //������Ϣ����
	if(ConfigDesc==""){
		alert("���õ���������Ϊ��");
		return 0;
	}
	
	var ConfigCommon=$('#ConfigCommon').val();          //��ע
	
	var ConfigActiveFlg=$('#ConfigActiveFlg').combobox('getValue') ;      //���ñ�־
	var HospitalNo=$('#HospitalNo').combobox('getValue') ;                    //ҽԺ����
	//var AuditFlg="0";   //$('#AuditFlg_Edit').combobox('getValue');
	//if($HUI.checkbox("#AuditFlg_Edit").getValue(true)){
	//	AuditFlg="1";
//}
		
	var RowDataInfo=ConfigCode+"^"+ConfigDesc+"^"+ConfigCommon+"^"+ConfigActiveFlg+"^"+HospitalNo;
	//alert("RowDataInfo="+RowDataInfo);
	var CommonDr=$('#ConfigDr').val();
	var RowIndex=$('#ConfigIndex').val();
	var LgUserID=session['LOGON.USERID'];
	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl"
		,MethodName:"SaveConfigPointAjax"
		,RowDataInfo:RowDataInfo
		,UserDr:LgUserID
		,CommonDr:CommonDr
		,RowIndex:RowIndex
	},function(data){

		if(data.Status>0){
			/*
			var tmpIndex=data.RowIndex;
			if(tmpIndex !=""){
				$('#DictionaryGV').datagrid('updateRow', {
					index:tmpIndex
					,row:data.Data
				});
			}else{
				$('#DictionaryGV').datagrid('appendRow', data.Data);
				var allRows=$('#DictionaryGV').datagrid('getRows');
				if(allRows.length>0){
					//alert("add after:"+allRows.length);
					tmpIndex=allRows.length-1;
					$('#DictionaryGV').datagrid('selectRow', tmpIndex);             //ѡ�����һ��
					$('#SelCommonDr').val(data.Status);                                   //���õ�ǰѡ�����ݵ�Dr
					$('#SelCommonIndex').val(tmpIndex);                                //���õ�ǰѡ�������
				}
			}
			SelectedCommonRow(tmpIndex, data.Data);    //ѡ���¼�
			*/
			reloadDictionaryGV('reload');
			
			$.messager.show({
				title:'��ʾ',
				msg:'����ɹ�',
				timeout:2000,
				showType:'slide'
				,through:true
			});
		}else{
			$.messager.alert("��ʾ","����ʧ�ܣ�"+data.info);
		}
		
	});
}

/// ����Ӱ�������ֵ���Ϣ
function SaveDicFactorInfo(){
	var ErrMsgInfo="";
	var FactorCode=$('#FactorCode').val();
	if(FactorCode==""){
		ErrMsgInfo=ErrMsgInfo+"���ر��벻��Ϊ��!\n";
	}
	var FactorDesc=$('#FactorDesc').val();
	if(FactorDesc ==""){
		ErrMsgInfo=ErrMsgInfo+"������������Ϊ��!\n";
	}
	var FactorCommon=$('#FactorCommon').val();
	var CheckClsName=$('#CheckClsName').val();
	var CheckMethodName=$('#CheckMethodName').val();
	var InputPamTag=$('#InputPamTag').val();
	
	var queryflg="";
	var queryClassName="";
	var queryMethodName="";
	if($("#queryflg").checkbox("getValue")){
		queryflg="1";
		queryClassName=$("#queryClass").val();
		queryMethodName=$("#queryMethod").val();
	}else{
		queryflg="0"
	}
	
	if(ErrMsgInfo != ""){
		alert(ErrMsg);
		return 0;
	}
	
	
	var RowDataInfo=FactorCode+"^"+FactorDesc+"^"+FactorCommon+"^"+CheckClsName+"^"+CheckMethodName+"^"+InputPamTag+"^"+""+"^"+queryflg+"^"+queryClassName+"^"+queryMethodName;
	var DataDr=$('#SelFactorDr').val();
	var RowIndex=$('#SelFactorIndex').val();
	var LgUserID=session['LOGON.USERID'];
	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl"
		,MethodName:"SaveConfigFactorAjax"
		,RowDataInfo:RowDataInfo
		,UserDr:LgUserID
		,DataDr:DataDr
		,RowIndex:RowIndex
	},function(data){

		if(data.Status>0){
			reloadAddStrategyGV('reload');   //���¼�������
			ClearFactorArea();         //��ձ༭����
			$.messager.show({
				title:'��ʾ',
				msg:'����ɹ�',
				timeout:2000,
				showType:'slide'
				,through:true
			});
		}else{
			alert(data.info);
		}
		
	});
}

// ɾ�������ֵ���Ϣ
function DeleteDicFactorInfo(){
	var DataDr=$('#SelFactorDr').val();
	
	$cm(
		{
			ClassName:"INSU.BL.ConfigPointCtl",
			MethodName:"DelConfigFactorDicAjax",
			FactorDr:DataDr
		},
		function(data){			
			if(parseInt(data.status)>0){
				
				reloadAddStrategyGV('reload');   //���¼�������
				ClearFactorArea();         //��ձ༭����
				$.messager.show({
					title:'��ʾ',
					msg:'ɾ���ɹ�',
					timeout:2000,
					showType:'slide'
					,through:true
				});
			}else{
				$.messager.alert("������ʾ","ɾ��ʧ�ܣ�"+data.info);
			}
		},
		'json'
	);
}

/*
// ���Կ�ά��
function StrategyEditewinFunction(){
	
	$('#Strategywin iframe').attr("src","../../pages/dictionmanger/dictionarystrategy.csp?hospitalNo="+$('input[name=hospitalNo]').val()+"&insuType="+$('input[name=insuType]').val());
	$('#Strategywin').window("open");
}

// ֪ʶ��ά��
function DictionaryEditewinFunction(){
	$('#Dictionarywin iframe').attr("src","../../pages/dictionmanger/dictionary.csp?hospitalNo="+$('input[name=hospitalNo]').val()+"&insuType="+$('input[name=insuType]').val());
	$('#Dictionarywin').window("open");
}
*/

///******************************************************************
///����˵����
///         �޲���֪ʶ���Ӧ�Ĳ��Խ���
///******************************************************************
function buildAllStrategyFunction(){
	var hospitalNo=$('input[name=hospitalNo]').val();
	var insuType=$('input[name=insuType]').val();
	var extStr="0^^";
	buildStrategyAjax(hospitalNo,insuType,extStr);
}

function buildStrategyAjax(hospitalNo,insuType,extStr)
{
	var Url=APP_PATH+"/dic.INSUQCDictionarySategySubCtl/BuildAllDictSategySubAjax" ;
	$.post(
		Url,
		{
			hospitalNo:hospitalNo,
			insuType:insuType,
			extStr:extStr
		},
		function(data,textStatus){
			if(textStatus=="success"){
				reloadDictionaryGV('load');
				$.messager.show({
					title:'��ܰ��ʾ',
					msg:data.info,
					timeout:2000,
					showType:'slide'
					,through:true
				});
				
				
			}else{
				$('#proWin').window('close');
				$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
			}
		},
		'json'
	);
}

///******************************************************************
///����˵����
///          ��ҳ���ȡ��
///******************************************************************
function updateCommitFunctionC(){
	//endEditRow();
	var userID=LgUserID;              //�û�ID
	
	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#StrategyGV').datagrid('getRows');                   //��ҳ��������
	var AllRowLen=AllrowRecs.length;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		if(objRowTmp.AuditFlg =="1"){   //ȡ������˵�����
			rowRecs.push(objRowTmp);
		}
	}
	
	//var rowRecs=$('#StrategyGV').datagrid('getChanges','updated');
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateStrategyInfo(0,rowLen,rowRecs,userID,"2");     //�������ȡ��
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'��ǰû���޸ĵĲ��������Ϣ',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

///******************************************************************
///����˵����
///          �޸��ύ��ť����
///******************************************************************
function updateCommitFunction(){
	//endEditRow();
	var userID=LgUserID;              //�û�ID
	
	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#StrategyGV').datagrid('getRows');                   //��ҳ��������
	var AllRowLen=AllrowRecs.length;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		if(objRowTmp.AuditFlg !="1"){
			rowRecs.push(objRowTmp);
		}
	}
	
	//var rowRecs=$('#StrategyGV').datagrid('getChanges','updated');
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateStrategyInfo(0,rowLen,rowRecs,userID,"1");     //�������
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'��ǰû���޸ĵĲ��������Ϣ',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

/// ����ύ��ť�¼�����
function AuditChangeCommitFunction(){
	//var userID=LgUserID;              //�û�ID
	//alert("FactorEditIndex="+FactorEditIndex);
	
	if(CheckConfigActiveFlg()!="1"){    //�Ƿ���Ա༭��֤
		return 0;
	}
	
	$("#StrategyGV").datagrid("endEdit",FactorEditIndex);
	var SelFactorRow=$("#StrategyGV").datagrid("getChanges");
	var checkRtn=checkFactorInfos(SelFactorRow)
	if(checkRtn=="1"){
		SaveConfigToFactor(SelFactorRow,0,"1");
	}
	
	/*
	if(SelFactorRow.length>0){
		SaveConfigToFactor(SelFactorRow,0,"1");
	}
	*/
}

/// ����˵������֤����ά�������Ƿ�����
function checkFactorInfos(FactorRows){
	var RtnFlg="0";
	var len=FactorRows.length;
	if(FactorRows.length>0){
		var ErrMsg="";
		var objRow="";
		var FactorDesc="";
		var FactorName="";
		var DataFrom="";
		var CompareVal="";
		var CompareStartVal="";
		var CompareEndVal="";
		var ErrMsgTmp="";
		var indexName="";
		for(index=0; index<len; index++){
			objRow=FactorRows[index];
			FactorDesc=objRow.FactorDesc;                     //���ط���
			FactorName=objRow.FactorName;                 //��������
			DataFrom=objRow.DataFrom;                        //������Դ
			CompareVal=objRow.CompareVal;                 //�̶�ֵ
			CompareStartVal=objRow.CompareStartVal;   //��Сֵ
			CompareEndVal=objRow.CompareEndVal;     //���ֵ
			indexName="��"+(index+1)+"��:";
			ErrMsgTmp="";
			if(FactorName==""){
				ErrMsgTmp="�������Ʋ���Ϊ��!";
			}
			if((DataFrom=="1")&&(CompareVal=="")){     //0 �������� 1 �̶�ֵ  2 ��������
				ErrMsgTmp=ErrMsgTmp+"��������Ϊ�̶�ֵ�ĳ��ϣ��̶�ֵ����Ϊ��!";
			}
			if((DataFrom=="2")&&((CompareStartVal=="")&&(CompareEndVal==""))){     //0 �������� 1 �̶�ֵ  2 ��������
				ErrMsgTmp=ErrMsgTmp+"��������Ϊ[��������]�ĳ��ϣ����ֵ����Сֵ����ͬʱΪ��!";
			}
			if(ErrMsgTmp!=""){
				ErrMsgTmp=indexName+ErrMsgTmp;
			}
			if(ErrMsg==""){
				ErrMsg=ErrMsgTmp;
			}else{
				ErrMsg=ErrMsg+"\n"+ErrMsgTmp;
			}
		}
		
		if(ErrMsg==""){
			RtnFlg="1";
		}else{
			alert(ErrMsg);
		}
	}else{
		alert("û�����ύ������!");
	}
	
	return RtnFlg;
}


/// ��ȡ�б��б�ѡ���е���������
function  GetCheckedRowIndexArr(StrategyGV){
	var CheckedIndexArr=[];
	var CheckedRowRecs=$('#'+StrategyGV).datagrid('getChecked');
	var len=CheckedRowRecs.length;
	var objTmp=null;
	var indexTmp=null;
	for(index=0; index<len; index++){
		objTmp=CheckedRowRecs[index];
		indexTmp=$('#'+StrategyGV).datagrid('getRowIndex', objTmp);
		CheckedIndexArr.push(indexTmp);
	}
	
	return CheckedIndexArr;
}

///******************************************************************
///����˵����
///          ���Ӳ��԰�ť����
///******************************************************************
function StrategyAddFunction(SearchFlg){
	//alert("StrategyAddFunction");
	//endEditRow();
	//$('#StrategyGV').datagrid('appendRow',{status:'P'});
	//clearDicStrategyDetail();
	
	/*
	var detailUserId=$('input[name=userId]').val();              //�û�ID
	var detailHostpitalNo=$('input[name=hospitalNo]').val();
	var detailInsuType=$('input[name=insuType]').val();
	$('#dicId').val(dicId);                                 //֪ʶ��ID
	$('#detailUserId').val(detailUserId);                   //�û�ID
	$('#detailHostpitalNo').val(detailHostpitalNo);         //ҽԺ����
	$('#detailInsuType').val(detailInsuType);               //ҽ������
	*/
	
	$('#AddStrategyGV').datagrid('loadData',{total:0,rows:[]});           //��ѯҳ���ʼ��
	if(SearchFlg=="1"){
		$('#AddOpenMode').val("1");     //��ģʽ  0 ��ͨ��  1 ������
		
		var strategykeySearchm=$('#strategykeySearchmain').searchbox('getValue');                          //���Ĵʹؼ���
		$('#strategykeySearch').searchbox('setValue', strategykeySearchm);
		reloadAddStrategyGV('load');
	}else{
		$('#strategykeySearch').searchbox('setValue', "");
		$('#AddOpenMode').val("0");     //��ģʽ  0 ��ͨ��  1 ������
	}
	
	var dicId=$('#rowid').val();
	if(dicId!=""){
		$('#addDictionary').window("open"); 
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'��ѡ��֪ʶ����Ϣ',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}


///******************************************************************
///����˵����
///          ����ɾ����ť����
///******************************************************************
function StrategyRemoveFunction(){
	endEditRow();
	
	var rowRecs=$('#StrategyGV').datagrid('getSelections');
	var rowLen=rowRecs.length;
	if(rowLen==1){
		var HaveExpFlg = $('#HaveExpFlg').val();   //�б��ʽ +dongkf 2015 05 06  
		if(HaveExpFlg==1){
			alert('���й�ʽ����ʱ����ɾ��!');
			/*-dongkf 2019 11 20  �����п��ܻ���Ҫ�޸�
			var DicItmDr=$('input[name=rowid]').val();
			var DicSubDr=rowRecs[0].DictionarySubDr;
			var HospitalNo=$('input[name=hospitalNo]').val();
			var InsuType=$('input[name=insuType]').val();
			var UseAdmType=$('input[name=UseAdmType]').val();
			var ExtStr=HospitalNo+"^"+InsuType+"^"+UseAdmType;
			StrategyRemoveExeHasExp(rowRecs,DicItmDr,DicSubDr,ExtStr);
			*/
		}else{
			StrategyRemoveExe(rowRecs);
		}
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'��ѡ��һ������',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

///******************************************************************
///����˵����
///          ��Ŀ������б��ʽ�Ĳ�����ϸɾ������
///�汾������dongkf 2015 05 07
///******************************************************************
function StrategyRemoveExeHasExp(rowRecs,DicItmDr,DicSubDr,ExtStr){
	var Url=APP_PATH+"/dic.INSUQCDictionarySategySubCtl/DeleteSategySubCheck";   //�����б��ʽ����Ŀ����Ҫ�жϱ��ʽ�Ƿ������ǰ�Ĳ���
	$.post(
		Url
		,{
			DicItmDr:DicItmDr
			,DicSubDr:DicSubDr
			,ExtStr:ExtStr
		}
		,function(data,textStatus){
			if(textStatus=="success"){
				if(data.status==1){
					StrategyRemoveExe(rowRecs);
				}else{
					$.messager.alert('��ܰ����',data.info);
				}
			}else{
				$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
			}
		},
		'json'
	);
}

///******************************************************************
///����˵����
///          ������ϸɾ������
///�汾������dongkf 2015 05 07
///******************************************************************
function StrategyRemoveExe(rowRecs){
		var ID=rowRecs[0].ItmStrategyDr;
		//alert("ItmStrategyDr="+ID);
		var Url=APP_PATH+"/dictool.ItmStrategyEditCtl/DelItmStrategy" ;
		$.post(
			Url,{ItmStrategyDr:ID},function(data,textStatus){
				if(textStatus=="success"){
					if(data.status>=0){
						reloadStrategyGV('reload');
						$.messager.show({
							title:'��ܰ��ʾ',
							msg:'����ɾ���ɹ���',
							timeout:2000,
							showType:'slide'
							,through:true
						});
					}else{
						$.messager.alert('����ʧ��','�����Ϣ����ʧ�ܣ���ϸ��Ϣ��'+data.rtnMsg);
					}
				}else{
					$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
				}
			},
			'json'
		);
}

///******************************************************************
///����˵����
///          �����ٽ�����ť����
///******************************************************************
function StrategyRedoFunction(){
	endEditRow();
	
	var rowid=$('input[name=rowid]').val();
	if(rowid!=""){
		//$('#reDoFlg').val("1");
		reloadStrategyGV('load');
		//$('#reDoFlg').val("0");
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'��ѡ��һ��֪ʶ������',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}

}

///******************************************************************
///����˵����
///          ������ϸȫ�����ͨ����ť����
///******************************************************************
function StrategySaveAllFunction(){
	endEditRow();
	var userID=$('input[name=userId]').val();              //�û�ID
	var rowRecs=$('#StrategyGV').datagrid('getRows');
	var rowLen=rowRecs.length;                             //������
	if(rowLen>0){
		UpdateStrategyInfo(0,rowLen,rowRecs,userID,"0");   //������˽��
		$('#proWin').window('open');
	}else{
		$.messager.show({
			title:'��ܰ��ʾ',
			msg:'û����Ҫ��˵Ĳ�����ϸ��Ϣ',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

///******************************************************************
///����˵����
///          ������ť�¼�����
///******************************************************************
function searchDictionaryInfo(){
	reloadDictionaryGV('load');
	/// ��ȡ���Եȼ��ͺ�̨���Ƶȼ�
	var hospitalNo=$('#hospitalNo').val();
	var insuType=$('#insuType').val();
	var data={
		hospitalNo:hospitalNo
		,insuType:insuType
	};
	
	//���Եȼ�
	$.get(
		APP_PATH+"/dic.INSUQCStrategyLevelCtl/getComboboxListAjax&hospitalNo="+hospitalNo+"&insuType="+insuType
		,function(data){
			StrategyArrLevel=data.data ;
		}
		,"json"
	);
	
	//���Ƶȼ�
	$.get(
		APP_PATH+"/dic.INSUQCControlLevelCtl/getComboboxListAjax&hospitalNo="+hospitalNo+"&insuType="+insuType
		,function(data){
			ControlLevel=data.data ;
		}
		,"json"
	);

	//���Ƶȼ�
	$.get(
		APP_PATH+"/com.INSUQCDicDataCtl/dicTypeList&dicType=Strategy_UseType"
		,function(data){
			data=comboboxLoadFilter(data);    //�жϺ�̨�����Ƿ���ִ���
			if(data.length>0){
				var useTypeArr=StrategyUseOption;
				var tmpUseType=null;
				var objUseType=null;
				for(i=0; i<data.length; i++){
					tmpUseType=data[i];
					objUseType=new Object();
					objUseType.code=tmpUseType.DicCode;
					objUseType.desc=tmpUseType.DicDesc;
					useTypeArr.push(objUseType);
				}
				$('#UseAdmType').combobox('clear');
				$('#UseAdmType').combobox('loadData',useTypeArr);
			}
		}
		,"json"
	);
}

///******************************************************************
///����˵����
///          ����������˽��
///����˵����DoType --> 0 �������ݸ��� 1 ��ҳ���ͨ��  2 ��ҳ���ȡ��
///******************************************************************
function UpdateStrategyInfo(i,len,rowRecs,userID,DoType){
	var objItmStrategyRow=null;
	if(DoType=="0"){     //��������
		objItmStrategyRow=rowRecs;
	}
	if((DoType=="1")||(DoType=="2")){    //��ҳ���ͨ�� �����Ƕ���
		objItmStrategyRow=rowRecs[i];
		if (DoType =="1" ) {  //��ҳ���ͨ��
			objItmStrategyRow.AuditFlg="1"; 
		}
		if (DoType =="2" ) {  //��ҳ���ȡ��
			objItmStrategyRow.AuditFlg="0"; 
		}
	}
	if(DoType=="3"){     //���״̬�ı�Ĳ��ύ
		objItmStrategyRow=rowRecs[i];
		var tmpAuditFlg=objItmStrategyRow.AuditFlg;
		if(tmpAuditFlg=="1"){
			tmpAuditFlg="0";
		}else{
			tmpAuditFlg="1";
		}
		objItmStrategyRow.AuditFlg=tmpAuditFlg;
	}
	
	var ItmStrategyInfo=BuildItmStrategyInfo(objItmStrategyRow);              //������Ŀ֪ʶ����Ϣ�ַ���
	var ItmStrategyDr=objItmStrategyRow.ItmStrategyDr;                            //֪ʶ��Dr
	//alert("ItmStrategyInfo="+ItmStrategyInfo+"||ItmStrategyDr="+ItmStrategyDr);
	//return 0;
	var Url=APP_PATH+"/dictool.ItmStrategyEditCtl/SaveItmStrategy" ;
	var data={
		ItmStrategyInfo:ItmStrategyInfo,
		ItmStrategyDr:ItmStrategyDr
	};
	//���������Ϣ
	$.post(Url,data,function(data,textStatus){
			if(textStatus=="success"){
				if(data.status>=0){
					var index=i+1;
					//$('#progress').progressbar('setValue',rate); //���ý�����ֵ
					if(index<len){     //�ж��Ƿ�������
						UpdateStrategyInfo(index,len,rowRecs,userID,DoType);
					}else{
						if((DoType=="1")||(DoType=="2")||(DoType=="3")){
							reloadStrategyGV('reload');
							alert("������!");
						}else{ //������˹��� ����ҳ��
							var tmpIndex=i;
							if(tmpIndex !=""){
								if(objItmStrategyRow.ItmStrategyDr==""){
									objItmStrategyRow.ItmStrategyDr=data.status;
								}
								
								$('#StrategyGV').datagrid('updateRow', {
									index:tmpIndex
									,row:objItmStrategyRow
								});
								//$('#StrategyGV').datagrid('refreshRow', tmpIndex);    //ˢ����
								$('#StrategyGV').datagrid('beginEdit', tmpIndex);
							}
						}
					}
					
					/*
					if(index==len){  //��˺����¼�������
						reloadStrategyGV('reload')
						$.messager.show({
							title:'��ܰ��ʾ',
							msg:'�����ɣ�',
							timeout:2000,
							showType:'slide'
							,through:true
						});
					}*/
				}else{
					//$('#proWin').window('close');
					$.messager.alert('����ʧ��','�����Ϣ����ʧ�ܣ���ϸ��Ϣ��'+data.info);
				}
			}else{
				//$('#proWin').window('close');
				$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
			}
		},'json');
}

///******************************************************************
///����˵����
///          ֪ʶ�����������¼���
///����˵����
///          loadType->load ���� reload
///******************************************************************
function reloadDictionaryGV(loadType){
	//var hospitalNo=$('#hospitalNo').val();
	//var insuType=$('#insuType').val();
	//var ComExtStr=hospitalNo+"^"+insuType;
	var ComExtStr="";
	
	var keywordIn=$('#keywordIn').searchbox('getValue');

	var InputPam=keywordIn+"^";
	$('#DictionaryGV').datagrid(loadType, {
		ClassName:"INSU.BL.ConfigPointCtl",
		QueryName:"SearchConfigPoint",
		InputPam: InputPam
	});
}

///���������������ݼ�
function reloadConfigFacDetailGV(loadType){
	var ConDataDr=$("#CofingFactorDr").val();
	//alert("ConDataDr="+ConDataDr);
	if(ConDataDr==null){
		$.messager.alert("��ʾ","��ѡ�����õ����أ�")
		return
	}
	
	$('#ConfigFacDetailGV').datagrid({
		url:$URL,
		queryParams: {
			ClassName:"INSU.BL.ConfigPointCtl",
			QueryName:"SearchFactorConfig",
			InputPam:ConDataDr
		}
	});

}

function setEditConfig(rowData){
	$("#ProCode").val(rowData.ProCode);
	$("#ProCodeCombo").combobox("setValue",rowData.ProCode);
	$("#ProName").val(rowData.ProName);
	$("#ProValue").val(rowData.ProValue);
	$("#ProActiveFlg").combobox('setValue',rowData.ActiveFlg)
}

function clearEditConfig(){
	$("#ProCode").val("");
	$("#ProName").val("");
	$("#ProValue").val("");
	$("#ProActiveFlg").combobox('setValue',1);
}

///******************************************************************
///����˵����
///          ֪ʶ�������ϸ������¼���
///����˵����
///          loadType->load ���� reload
///******************************************************************
function reloadStrategyGV(loadType){

	var SelectDic=$("#DictionaryGV").datagrid("getSelected");
	if(SelectDic==""){
		return
	}
	
	var PointRowID=SelectDic.RowID;
	
	$("#StrategyGV").datagrid({
		className:"INSU.BL.ConfigPointCtl",
		queryName:"SearchFactorsByConfig", 
		url:$URL+"?ClassName=web.Test&QueryName=LookUp&InputPam="+PointRowID,
	});
}

///******************************************************************
///����˵����
///          ֪ʶ�������ϸ������¼���
///����˵����
///          loadType->load ���� reload
///******************************************************************
function reloadAddStrategyGV(loadType){
	
	var InputPam="";
	var strategykeySearch=$('#strategykeySearch').searchbox('getValue');                          //���Թؼ���
	InputPam=strategykeySearch+"^";
	//alert("InputPam="+InputPam);
	//���ؾ����б�
	/*
	$('#AddStrategyGV').datagrid(loadType,{
		InputPam:InputPam
	} ) ;
	*/
		
	$('#AddStrategyGV').datagrid({
		url:$URL,
		queryParams: {
			ClassName:"INSU.BL.ConfigPointCtl",
			QueryName:"SearchDicFactor",
			InputPam:InputPam
		}
	});
}

///******************************************************************
///����˵����
///          ֪ʶ���Ӧ�Ĳ�����Ϣ���
///******************************************************************
function DictionaryStrategyInfoClear(){
	
	/*
	//֪ʶ����ϸ��Ϣ���
	$('#DataSourceDesc').text("");
	$('#DataSource').val("");
	$('#rowid').val("");
	$('#reDoFlg').val("0");
	$('#dataTypeDesc').text("");         //��˱�־
	$('#dataType').val("");
	
	$('#Code').text("");                 //����
	$('#Desc').text("");                 //����
	$('#MedicineUnique').text("");       //��ĿΨһ��
	$('#ElectronicCode').text("");       //��Ŀ������
	$('#Explain').val("");               //ҽ��˵��
	$('#Remarks').val("");               //ҽ����ע
	*/
	
	$('#rowid').val("");                 //ѡ�����ĿDr
	$('#ItmCode').val("");            //ѡ�����Ŀ����
	$('#ItmDesc').val("");             //ѡ�����Ŀ����
	$('#HaveExpFlg').val("0");             //�Ƿ��й�ʽ
	
	//endEditRow();                        //�༭״̬ȡ��
	//reloadStrategyGV('load');            //����ϸ�����
	$('#StrategyGV').datagrid('loadData',{total:0,rows:[]});
	
	FormulaClear();   //��ղ���������
	
}

/// ���ñ�ע��Ϣά������
function setEditCommonArea(){
	$('#Edit_Common_Area').window({
		title:'��������ѡ��',
		width:680,
		height:310,
		modal:true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		onBeforeClose:function(){
			ClearCommonEditArea();
		}
		,onBeforeOpen:function(){    //��֮ǰ��ʼ������
			ClearCommonEditArea();                     //���ԭ������
			SetCommonEditAreaBySel();                //����ѡ��ı�ע���ñ༭�������
		}
	});
	$('#Edit_Common_Area').window("close");
	
	$('#Edit_Factor_Area').window({
		title:'��������ά��',
		width:800,
		height:600,
		modal:true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		onBeforeClose:function(){
			ClearFactorArea();
		}
		,onBeforeOpen:function(){    //��֮ǰ��ʼ������
			ClearFactorArea();                     //���ԭ������
			SetFactorArea();                //����ѡ��ı�ע���ñ༭�������
		}
	});
	$('#Edit_Factor_Area').window("close");
	
	$("#Edit_ConfigMap_Area").window({
		title:'���������ֵ�',
		width:800,
		height:600,
		modal:true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		onBeforeClose:function(){
			$('#ProCode').css('display','none');
			$('#ProCodeCombo').css('display','none');
		}
		,onBeforeOpen:function(){    //��֮ǰ��ʼ������
			//clearEditConfig();
			reloadConfigFacDetailGV('load')                     //���ر�������	
				
		}
	});
	$("#Edit_ConfigMap_Area").window("close");
	
	//Ӱ�����ص��ֵ�Ŀ�ѡֵά�����涨��
	$("#FactorDic_Details_Area").window({
		title:'���������ֵ�',
		width:800,
		height:600,
		modal:true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		onBeforeClose:function(){
			//$('#ProCode').css('display','none');
			$('#FactorDicDr').val("");
		}
		,onBeforeOpen:function(){    //��֮ǰ��ʼ������
			reloadFactorDicDetailGV('load');                     //���ر�������	
		}
	});
	$("#FactorDic_Details_Area").window("close");
}


/// ����ѡ��ı�ע��Ϣ���ñ༭�����ֵ
function SetCommonEditAreaBySel(){
	
	var SelCommonRow=$('#DictionaryGV').datagrid('getSelected');                                            //ѡ�е���
	if (SelCommonRow!=null){
		var ConfigIndex=$('#DictionaryGV').datagrid('getRowIndex', SelCommonRow);       //ѡ�е�������
		//console.log(SelCommonRow)
		var ConfigDr=SelCommonRow.RowID;                        //��עDr
		var ConfigCode=SelCommonRow.ConfigCode;              //���õ����
		var ConfigDesc=SelCommonRow.ConfigDesc;               //���õ���������
		var ConfigCommon=SelCommonRow.ConfigCommon;            //��ע��Ϣ
		var ConfigActiveFlg=SelCommonRow.ActiveFlg;             //�Ƿ����� 1 ���� 0 δ����
		var HospitalNo=SelCommonRow.HospitalNo;                //Ժ������
		
		$('#ConfigDr').val(ConfigDr);
		$('#ConfigIndex').val(ConfigIndex);
		$('#ConfigCode').val(ConfigCode);
		$('#ConfigDesc').val(ConfigDesc);
		$('#ConfigCommon').val(ConfigCommon);
		$('#ConfigActiveFlg').combobox('setValue', ConfigActiveFlg);
		if(HospitalNo==""){
			$('#HospitalNo').combobox('clear');
		}else{
			$('#HospitalNo').combobox('setValue', HospitalNo);
		}
	}
}

/// ��ʼ����ձ�ע�༭�������Ϣ
function ClearCommonEditArea(){
	$('#ConfigDr').val("");
	$('#ConfigIndex').val("");
	$('#ConfigCode').val("");
	$('#ConfigDesc').val("");
	$('#ConfigCommon').val("");
	$('#ConfigActiveFlg').combobox('setValue', '0');
	$('#HospitalNo').combobox('clear');
}

function SetFactorArea(){
	var SelectFactor=$("#AddStrategyGV").datagrid("getSelected");
	//alert(SelectFactor);
	if(SelectFactor!=null){
		var FactorIndex=$("#AddStrategyGV").datagrid("getRowIndex",SelectFactor);
		
		$("#SelFactorDr").val(SelectFactor.RowID);
		$("#SelFactorIndex").val(FactorIndex);
		$("#FactorCode").val(SelectFactor.FactorCode);
		$("#FactorDesc").val(SelectFactor.FactorDesc);
		$("#FactorCommon").val(SelectFactor.FactorCommon);
		$("#CheckClsName").val(SelectFactor.CheckClsName);
		$("#CheckMethodName").val(SelectFactor.CheckMethodName);
		$("#InputPamTag").val(SelectFactor.InputPamTag);
		//$("#DataFromFactor").combobox('setValue',SelectFactor.DataFrom);
		$("#queryClass").val(SelectFactor.XStr2);
		$("#queryMethod").val(SelectFactor.XStr3);
		
		var queryflg=SelectFactor.XStr1;
		if(queryflg=="1"){
			$("#queryflg").checkbox("check");
			$("#queryInfoArea").show();
		}
		
	}
}

function ClearFactorArea(){
	$("#SelFactorDr").val("");
	$("#SelFactorIndex").val("");
	$("#FactorCode").val("");
	$("#FactorDesc").val("");
	$("#FactorCommon").val("");
	$("#CheckClsName").val("");
	$("#CheckMethodName").val("");
	$("#InputPamTag").val("");
	//$("#DataFromFactor").combobox("setValue","1");
	$("#queryflg").checkbox("uncheck");
	$("#queryClass").val("");
	$("#queryMethod").val("");
	$("#queryInfoArea").hide();
	
}

///******************************************************************
///����˵����
///          ֪ʶ���Ӧ�Ĳ�����Ϣ���
///******************************************************************
function setAddDictionary(){
	$('#addDictionary').window({    
		title:'Ӱ��Ԫ���б�',
		width:900,
		height:600,
		modal:true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closable:true,
		onBeforeClose:function(){
			//$('#searchPanel').hide();
		}
	});
	$('#addDictionary').window("close");
	
	
}

function setDictionaryShowMsg(rowIndex, rowData){
	$('#detailId').val(rowData.RowID);
	$('#dictionaryCDText').text(rowData.StrategyCode);
	$('#dictionaryDescText').text(rowData.StrategyDesc);
	$('#dictionaryLevelText').text(rowData.SubCate);
	$('#dictionaryctlText').text(rowData.ControlLevel);
	
	$('#searchPanel').hide();
	$('input[name=searchDickey]').val("");
}

function regAddDictionaryEvent(){
	//�ܼ�������
	//$('input[name=searchDickey]').on('keyup',reloadResult);  //�������������������ʾ
	
	//ȡ����ť����
	$('#addCancelBtn').on('click',function(){
		$('#addDictionary').window("close");
	});
	
	//��Ӳ�����ϸ
	//$('#addConfirmBtn').on('click', SaveSelectedStrategys);          //����ѡ��Ĳ�����Ϣ
	$('#addConfirmBtn').on('click', SaveConfigToFactors);				//������Ŀ��Ӧ�Ĳ��Թ�����Ϣ
}

//������Ŀ��Ӧ�Ĳ��Թ�����Ϣ
function SaveConfigToFactors(){
	//var SelectedRows=$('#AddStrategyGV').datagrid('getSelections');          //ѡ��Ĳ�����
	var SelectedRows=$('#AddStrategyGV').datagrid('getChecked');              //ѡ��Ĳ�����
	//console.log(SelectedRows)
	if(SelectedRows.length>0){     //ѡ���˵Ĳ��Ա���
		SaveConfigToFactor(SelectedRows, 0, "1");           //������Ŀ�Ĳ�����Ϣ
	}else{
		alert("������ѡ��һ�����Թ���!");
	}
}

function SaveConfigToFactor(SelectedRows, index, MutiFlg){
	var objItmConfigRow=null;
	if(MutiFlg=="1"){    //�������ݵĳ���
		var StrateLen=SelectedRows.length;              //������Ŀ
		if(index >= StrateLen){
			alert("��β���ȷ,����ϵ������Ա!");
			return 0;
		}else{
			objItmConfigRow=SelectedRows[index];
		}
	}else{
		objItmConfigRow=SelectedRows;               //�������ݵĳ���
	}
	var DictionaryRow=$('#DictionaryGV').datagrid('getSelected');
	var CollocationDr=DictionaryRow.RowID;			//���õ�Dr
	var FactorDr=objItmConfigRow.RowID;			  	//��������Dr
	var CompareVal=objItmConfigRow.CompareVal;							    //���رȽ�ֵ
	
	if(CompareVal==undefined){
		CompareVal="";
	}
	var CompareStartVal=objItmConfigRow.CompareStartVal;							//���صķ�Χ��ʼֵ
	if(CompareStartVal==undefined){
		CompareStartVal="";
	}
	var CompareEndVal=objItmConfigRow.CompareEndVal;							//���صķ�Χ����ֵ
	if(CompareEndVal==undefined){
		CompareEndVal="";
	}
	
	var DataFrom = objItmConfigRow.DataFrom;
	var CompareNM = objItmConfigRow.CompareNM;
	if(CompareNM==undefined){
		CompareNM="";
	}
	var FactorName = objItmConfigRow.FactorName;
	if(FactorName==undefined){
		FactorName="";
	}
	
	var AuditFlg="";
	if ("AuditFlg" in objItmConfigRow){
		AuditFlg=objItmConfigRow.AuditFlg;     //��˱�־
	}
	
	var XStr1="";
	var XStr2="";
	var XStr3="";
	var XStr4="";
	var XStr5="";
	var XStr6="";
	var ConfigToFactorInfo=CollocationDr+"^"+FactorDr+"^"+CompareVal+"^"+CompareStartVal;              //������Ŀ֪ʶ����Ϣ�ַ���
	var ConfigToFactorInfo=ConfigToFactorInfo+"^"+CompareEndVal+"^"+AuditFlg+"^"+XStr1;
	var ConfigToFactorInfo=ConfigToFactorInfo+"^"+XStr2+"^"+XStr3+"^"+XStr4+"^"+XStr5+"^"+XStr6+"^"+DataFrom+"^"+CompareNM+"^"+FactorName;
	//var UserDr=LgUserID;                                 //����ԱDr
	var UserDr=session['LOGON.USERID'];
	
	if("ConDataDr" in objItmConfigRow){
		var ConfigToFactorDr=objItmConfigRow.ConDataDr;	   //��������ID
	}else{
		var ConfigToFactorDr="";
	}
	
	
	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"SaveConfigToFactor",
		ConfigToFactorInfo:ConfigToFactorInfo,
		ConfigToFactorDr:ConfigToFactorDr,
		UserDr:UserDr
	},function(data){
		if(data.status < 0){
			alert(data.Info);
		}
		if(MutiFlg=="1"){    //�������ݵĳ���
			if(index<(StrateLen-1)){
				index=index+1;
				SaveConfigToFactor(SelectedRows, index, MutiFlg);           //��һ��ѡ��Ĳ���
			}else{
				
			}
		}
		$.messager.show({
			title:'��ʾ',
			msg:'�������ӳɹ���',
			timeout:1000,
			showType:'slide',
			style:{
				right:'',
				top:document.body.scrollTop+document.documentElement.scrollTop,
				bottom:''
			}
		});
		reloadStrategyGV("load");
	});
}

/// Ӱ�����ط��� ��ѡֵ����
function FDetaiAddBtnFun(){
	var FactorDicDr = $("#FactorDicDr").val();
	if(FactorDicDr==""){
		$.messager.alert("��ʾ","δѡ�����ط�����Ϣ����رմ�������ѡ��");
		return;
	}
	
	var FactorDetailDr= $("#FactorDetailDr").val();
	var FDetailCode= $("#FDetailCode").val();
	var FDetailName= $("#FDetailName").val();
	var FDetaiValue= $("#FDetaiValue").val();
	var FDetaiActiveFlg= $('#FDetaiActiveFlg').combobox('getValue');
	var XStr1="";
	var XStr2="";
	var XStr3="";
	var XStr4="";
	var XStr5="";
	
	if(FDetailCode==""){
		$.messager.alert("��ʾ","���벻��Ϊ��!");
		return;
	}
	
	var Details=FactorDicDr+"^"+FactorDetailDr+"^"+FDetailCode+"^"+FDetailName+"^"+FDetaiValue+"^"+FDetaiActiveFlg+"^"+XStr1+"^"+XStr2+"^"+XStr3+"^"+XStr4+"^"+XStr5;
	//alert("Details="+Details);
	var UserDr=session['LOGON.USERID'];

	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"SaveFactorDicDetail",
		ConfigStr:Details,
		UserDr:UserDr
	},function(data){
		if(parseInt(data.status) <= 0){
			$.messager.alert("��ʾ","����ʧ�ܣ�"+data.info);
		}else{
			reloadFactorDicDetailGV("load");
			clearFactorDicDetailEdit();
			$.messager.show({
				title:'��ʾ',
				msg:'����ɹ���',
				timeout:1000,
				showType:'slide',
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}
			});
		}
		
	});
}

function SaveFactorConfigInfo(){
	var CofingFactorDr = $("#CofingFactorDr").val();
	if(CofingFactorDr==""){
		$.messager.alert("��ʾ","δѡ��������Ϣ����رմ�������ѡ��");
		return;
	}
	
	var ProCode=""
	if($("#queryflg").val()=="1"){
		ProCode=$("#ProCodeCombo").combobox("getValue");             //�����������ʾ��������ȡ����������		
	}else{
		ProCode=$("#ProCode").val();   //����������״̬����ȡ�ı�������		
	}
	if(ProCode==""){
		$.messager.alert("��ʾ","���ñ��벻��Ϊ�գ�");
		return;
	}
	//var ProCode=$("#ProCode").val();
	var ProName=$("#ProName").val();
	var ProValue="";
	var ActiveFlg=$("#ProActiveFlg").combobox("getValue");
	
	var Instr=CofingFactorDr+"^"+ProCode+"^"+ProName+"^"+ProValue+"^"+ActiveFlg+"^"+1;
	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"SaveConfigDetail",
		ConfigStr:Instr
	},function(data){
		if(parseInt(data.status) <= 0){
			$.messager.alert("��ʾ","����ʧ�ܣ�"+data.info);
		}else{
			reloadConfigFacDetailGV("load");
			clearEditConfig();
			$.messager.show({
				title:'��ʾ',
				msg:'����ɹ���',
				timeout:1000,
				showType:'slide',
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}
			});
		}
		
	});
}

function DeletFactorConfig(){
	var DelConfig=$("#ConfigFacDetailGV").datagrid("getSelected");
	if(DelConfig == null){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ��������");
		return;
	}
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"DeletFactorConfig",
		ConfigDr:DelConfig.RowID
	},function(data){
		if(parseInt(data.status)>0){
			reloadConfigFacDetailGV("load");
			clearEditConfig();
			$.messager.show({
				title:'��ʾ',
				msg:'ɾ���ɹ���',
				timeout:1000,
				showType:'slide',
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}
			});
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�"+data.info);
		}
	})
}

//ɾ�������ֵ�Ŀ�ѡֵ��Ϣ
function FDetaiDelBtnFun(){
	var FactorDetailDr=$("#FactorDetailDr").val();
	if(FactorDetailDr == null){
		$.messager.alert("��ʾ","��ѡ����Ҫɾ��������");
		return;
	}
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"DelFactorDicDetail",
		FactorDetailDr:FactorDetailDr
	},function(data){
		if(parseInt(data.status)>0){
			reloadFactorDicDetailGV("load");
			clearFactorDicDetailEdit();
			$.messager.show({
				title:'��ʾ',
				msg:'ɾ���ɹ���',
				timeout:1000,
				showType:'slide',
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}
			});
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�"+data.info);
		}
	});
}

///ɾ�����õ�����صĹ�����ϵ
function DeletConFactor(){
	var ConDataDr = $("#CofingFactorDr").val();
	var SelConFac = $("#StrategyGV").datagrid("getSelected");
	if(SelConFac==null){
		$.messager.alert("��ʾ","δѡ����Ҫɾ��������");
		return;
	}
	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"DeletConFac",
		ConFactorDr:SelConFac.ConDataDr
	},function(data){
		if(parseInt(data.status)>0){
			reloadStrategyGV("load");
			$.messager.show({
				title:'��ʾ',
				msg:'ɾ���ɹ���',
				timeout:1000,
				showType:'slide',
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}
			});
		}else{
			$.messager.alert("��ʾ","ɾ��ʧ�ܣ�"+data.info);
		}
	})
}

function SaveSelectedStrategys(){
	
	var SelectedRows=$('#AddStrategyGV').datagrid('getSelections');          //ѡ��Ĳ�����
	if(SelectedRows.length>0){     //ѡ���˵Ĳ��Ա���
		SaveItmStrategy(SelectedRows, 0, "1");           //������Ŀ�Ĳ�����Ϣ
	}else{
		alert("������ѡ��һ�����Թ���!");
	}
}

function SaveItmStrategy(SelectedRows, index, MutiFlg){
	var objItmStrategyRow=null;
	if(MutiFlg=="1"){    //�������ݵĳ���
		var StrateLen=SelectedRows.length;              //������Ŀ
		if(index >= StrateLen){
			alert("��β���ȷ,����ϵ������Ա!");
			return 0;
		}else{
			objItmStrategyRow=SelectedRows[index];
		}
	}else{
		objItmStrategyRow=SelectedRows;               //�������ݵĳ���
	}

	var ItmStrategyInfo=BuildItmStrategyInfo(objItmStrategyRow);              //������Ŀ֪ʶ����Ϣ�ַ���
	//alert("ItmStrategyInfo="+ItmStrategyInfo);
	//return 0;
	var ItmStrategyDr="";
	if (("ItmStrategyDr" in objItmStrategyRow)) {
		ItmStrategyDr = objItmStrategyRow.ItmStrategyDr;                            //֪ʶ��Dr
	}
	
	$.post(
		APP_PATH+"/dictool.ItmStrategyEditCtl/SaveItmStrategy",
		{
			ItmStrategyInfo:ItmStrategyInfo
			,ItmStrategyDr:ItmStrategyDr
		},
		function(data,textStatus){
			if(textStatus=="success"){
				if(data.status < 0){
					alert(data.Info);
				}
				//alert(data.Info);
				if(MutiFlg=="1"){    //�������ݵĳ���
					if(index<(StrateLen-1)){
						index=index+1;
						SaveItmStrategy(SelectedRows, index, MutiFlg);           //��һ��ѡ��Ĳ���
					}else{
						reloadStrategyGV('reload');
						
						var AddOpenMode=$('#AddOpenMode').val();
						if(AddOpenMode=="1"){    //��ѯ����ģʽ��ʱ��������ɺ󣬹رմ���
							$('#addDictionary').window("close");
						}
					}
				}
			}else{
				$.messager.alert('ϵͳ����','ϵͳ�쳣�����Ժ�����');
			}
		},
		'json'
	);
}

/// ����˵����������Ŀ֪ʶ����Ϣ�ַ���
function BuildItmStrategyInfo(objItmStrategyRow)
{
	var HospitalNo=$('#hospitalNo').val();                    //1 ҽԺ����
	var InsuType =$('#insuType').val();                         //2 ҽ������
	var DataFrom=$("#DataFrom").val();                       //3 <!-- ������Դ(0 ҽ���ط���Ŀ�� 1 ���������뵽ҽ���طѵ�his��Ŀ 2 ֱ�Ӵ�his���շ���Ŀ���в�ѯ)  -->
	var ItmDr=$("#rowid").val();                                    //4 ��Ŀ��Dr
	var ItmCode=$("#ItmCode").val();                           //5 ��Ŀ����
	var ItmDesc=$("#ItmDesc").val();                             //6 ��Ŀ����
	var StrategyDr=objItmStrategyRow.RowID                                             //7 ���Ĵ�Dr
	var StrategyCode=objItmStrategyRow.KeywordCode;                             //8 ���Ĵʱ���
	var StrategyDesc=objItmStrategyRow.Keyword;                                     //9 ���Ĵ�����
	var StrategyUseVal="";     //objItmStrategyRow.StrategyUseVal;                         //10 ʹ�ó���
	var AuditFlg="0";                                             //11 ��˱�־
	if(("AuditFlg" in objItmStrategyRow)){
		AuditFlg=objItmStrategyRow.AuditFlg;
	}
	var ControlLevel="";  //objItmStrategyRow.ControlLevel;                                 //12 ���Ƶȼ�
	var DetailLevel="";    //objItmStrategyRow.DetailLevel;                                      //13 ���Եȼ�
	var Formula="";       //objItmStrategyRow.Formula;                                              //14 ���Թ�ϵ
	var UserDr=LgUserID;                                                                             //15 ����ԱDr
	var DataFrom=$('#DataFrom').val();                //������Դ 0 ҽ���ط���Ŀ�� 1 ���������뵽ҽ���طѵ�his��Ŀ 2 ֱ�Ӵ�his���շ���Ŀ���в�ѯ
	
	//1 ҽԺ����^2 ҽ������^3 ������Դ^4 ��Ŀ��Dr^5 ��Ŀ����^6 ��Ŀ����^7 ���Թ���Dr^8 ���Թ������^9 ���Թ�������^10 ʹ�ó���^11 ��˱�־^12 ���Ƶȼ�^13 ���Եȼ�^14 ���Եȼ�^15 ����ԱDr
	var ItmStrategyInfo=HospitalNo+"^"+InsuType+"^"+DataFrom+"^"+ItmDr+"^"+ItmCode;
	ItmStrategyInfo=ItmStrategyInfo+"^"+ItmDesc+"^"+StrategyDr+"^"+StrategyCode+"^"+StrategyDesc+"^"+StrategyUseVal;
	ItmStrategyInfo=ItmStrategyInfo+"^"+AuditFlg+"^"+ControlLevel+"^"+DetailLevel+"^"+Formula+"^"+UserDr+"^"+DataFrom;
	//var ItmStrategyDr=objItmStrategyRow.ItmStrategyDr;                            //֪ʶ��Dr
	
	return ItmStrategyInfo;
}


function bindEidtformul()
{
	$HUI.radio("[name='FormulaType']",{
		
		onChecked:function(e,value){
			//FormulaTypeChange(e, $(this).val());
			//alert("this vale="+$(this).val());
			if($(this).val() == "1")
			{
				$('#UseFlag').show();
				LoadStrategySubList();
			}
			else{
				$("#ClearAll").click() ;
				$("#StrategySubList").html("") ;
				$("#Eidtformul").html("") ;
				$("#UseFlag").hide();
			}
		}
	}) ;
	/*
	$("#Eidtformul a").live("click",function(){
		Reoveformul($(this)) ;
		return false ;
	});*/
	
	//$("#StrategySubList a").live("click",function(){      ///live������jquery1.9�����ϵİ汾���ѱ�������
	//	Addformul($(this)) ;
	//	return false ;
	//});
	
	$("#Eidtformul").on("click",'a',function(){
		Reoveformul($(this)) ;
		return false ;
	});
	
	$("#StrategySubList").on("click",'a',function(){
		Addformul($(this)) ;
		return false ;
	});
	
	
	$("#formulBtn .default .btn").click(AddOperator) ;
	
	$("#ClearAll").click(function(){
		$("#Eidtformul a").click();
		return false ;
	}) ;
	
	$("#BackFormul").click(function(){
		$("#Eidtformul a:last").click();
		return false ;
	}) ;
	
	$("#SaveFormul").click(function(){
		SaveFormulFun() ;
		return false ;
	});
	
	$("#DeleteFormul").click(function(){
		if(CheckConfigActiveFlg()!="1"){    //�Ƿ���Ա༭��֤
			return 0;
		}
		
		$.messager.confirm("ɾ��", "ȷ��ɾ����ǰ��ʽ?", function (r) {
			if (r) {
				DeleteFormul();
			} 
		});
		
		
	}) ;
	
	
	
	$("#EidtGroupFormu").mouseleave(function(event){
		var size=$("#Eidtformul").find("a").size();
		if(size== 0){
			if($("input[name=FormulaType]:checked").val() != "1")
			{
				return false ;
			}
			var tip=$("#Eidtformul").attr("tip") ;
			if((typeof tip!="undefined") && (tip!=""))
			{
				$("#Eidtformul").html("<a>"+tip+"</a>") ;
			}
		}
	}) ;
	
}

function Reoveformul(Element){
	Element.remove() ;
}

function Addformul(Element){
	if($("input[name=FormulaType]:checked").val() != "1")
	{
		$.messager.alert("��ʾ","�༭�����ʽ���ã�") ;
		return false ;
	}
	var Data=Element.data("Data") ;
	$(BuitlByData(Data)).data("Data",Data).appendTo("#Eidtformul") ;
	//Element.remove() ;
}

function AddOperator()
{
	if($("input[name=FormulaType]:checked").val() != "1")
	{
		$.messager.alert("��ʾ","�༭�����ʽ���ã�") ;
		return false ;
	}
	
	var html=$(this).html() ;
	html="<a type='Operator'>"+html+"</a>" ;
	$("#Eidtformul").append(html) ;
}

function BuitlByData(Data){
	var optionName=Data.FactorName;   //���ʽ����������
	if(optionName==""){
		optionName=Data.FactorDesc;
	}
	var html="<a type='Data'>"+optionName+"</a>" ;
	return $(html).data("Data",Data) ;
}

function LoadStrategySubList()
{
	$("#ClearAll").click() ;
	$("#StrategySubList").html("") ;
	
	//+dongkf 2015 07 31 start
	var Data=$('#StrategyGV').datagrid("getData") ;
	if("rows" in Data){
		DataRows=Data.rows;
	}else{
		return ;
	}
	//+dongkf 2015 07 31 end
	
	var Len=DataRows.length ;
	var AuditFlg="0";
	for(var i=0 ; i < Len ; i++ )
	{
		var Data=DataRows[i] ;
		AuditFlg=Data.AuditFlg;     //��˱��
		if(AuditFlg !="1") {
			continue;
		}
		BuitlByData(Data).appendTo("#StrategySubList") ;
	}
}

function SaveFormulFun(){
	if(CheckConfigActiveFlg()!="1"){    //�Ƿ���Ա༭��֤
		return 0;
	}
	
	if($("input[name=FormulaType]:checked").val() != "1")
	{
		$.messager.alert("��ʾ","�༭�����ʽ���ã�") ;
		return false ;
	}
	var ExpresArray=new Array() ;
	var ExpresDescArray=new Array() ;
	$("#Eidtformul a").each(function(){
		var Type=$(this).attr("type") ;
		if(Type == "Data"){
			var Data=$(this).data("Data") ;
			
			/*
			ExpresArray.push(Data.ItmStrategyDr) ;
			ExpresDescArray.push(Data.StrategyDesc) ;
			*/
			ExpresArray.push(Data.ConDataDr) ;
			var optionName=Data.FactorName;   //���ʽ����������
			if(optionName==""){
				optionName=Data.FactorDesc;
			}
			ExpresDescArray.push(optionName) ;
		}
		else if(Type =="Operator"){
			var Data=$(this).text() ;
			//console.log("Operator,"+Data);
			ExpresArray.push(Data) ;
			ExpresDescArray.push(Data) ;
		}
	});

	var FormulaType=$("input[name=FormulaType]:checked").val();
	//if(ExpresArray.length==0){   //-dongkf 2015 04 17
	if((ExpresArray.length==0) && (FormulaType=="1")){ 
		var tip=$("#Eidtformul").attr("tip") ;
		if((typeof tip!="undefined")||(tip!=""))
		{
			$.messager.alert("��ʾ","���Թ�ʽû���޸�,����Ҫ���棡") ;
			return false ;
		}
		$.messager.alert("��ʾ","��ʽ����Ϊ�գ�") ;
		return false ;
	}
	
	//�жϹ�ʽ�Ƿ���ȷ
	if((ExpresArray.length>0) && (FormulaType=="1")){
		var exption=ExpresArray.join("");
		if(checkExption(exption)==false){
			return false;
		}
	}
	
	var ToDay=new Date() ;
	var RowID=$("#ExpressionDr").val() ;
	var CollecationDr=$("#rowid").val();
	//var FormulaType=$("input[name=FormulaType]:checked").val();
	var Expression=ExpresArray.join("") ;
	var ExpressionDesc=ExpresDescArray.join("");
	
	var ExpressionCommon="";
	var ActiveFlg="1";
	var ActiveDtBegin="2019-12-12";
	var ActiveDtEnd="9999-12-31";
	var UpdateUser=session['LOGON.USERID'];
	var XStr1="";
	var XStr2="";
	var XStr3="";
	var XStr4="";
	var XStr5="";
	//var UseAdmType=$("#UseAdmType").combobox("getValue");                     //��ȡ���ʽ��ʹ�ó���  C->ͨ�� I->סԺ O->סԺ����
	//alert("UseAdmType="+UseAdmType);
	
	var InStr=CollecationDr+"^"+FormulaType+"^"+Expression+"^"+ExpressionDesc ;
	InStr=InStr+"^"+ExpressionCommon+"^"+ActiveFlg+"^"+ActiveDtBegin+"^"+ActiveDtEnd;
	InStr=InStr+"^"+XStr1+"^"+XStr2+"^"+XStr3+"^"+XStr4+"^"+XStr5+"^"+UpdateUser  ;
	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"SaveExpInfoAjax",
		ExpStr:InStr		
	},function(data){
		
		if(data.status>0){
			$.messager.show({
				title:'��ʾ',
				msg:'���ݱ���ɹ���',
				timeout:2000,
				showType:'slide'
				,through:true
			});
			$("#Eidtformul").attr("tip",ExpressionDesc) ;
			$("#WarnInfo").html("&nbsp;") ;
		}else{
			$.messager.alert("��ʾ","��������ʧ�ܣ�ErrInfo��"+data.info) ;
		}
	},"json") ;
}
// ɾ���Ѿ����ڵĹ�ʽ
function DeleteFormul()
{
	if($("#Eidtformul").attr("tip")==""){
		$.messager.show({
			title:'��ʾ',
			msg:'�޹�ʽ��',
			timeout:2000,
			showType:'slide'
			,through:true
		}) ;
		
		return 0;
	}
	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"DeleteExp",
		CollecationDr:$("#rowid").val()
	},function(data){
		
		if(data.status>0){
			$.messager.show({
				title:'��ʾ',
				msg:'ִ�гɹ���',
				timeout:2000,
				showType:'slide'
				,through:true
			}) ;
			
			$("#HaveExpFlg").val("0");   //ɾ�����ʽ�󣬱��ʽ״̬��Ҫ�޸� +dongkf 2015 05 06
			$("#Eidtformul").attr("tip","");
			$("#WarnInfo").html("&nbsp;") ;
			$("#OldExpression").html(" ") ;
			//$("input[name=FormulaType][value=2]").click() ;
			//$HUI.radio("input[name=FormulaType][value=2]").setValue(true);
			$("#Eidtformul").html("") ;    //+dongkf 2020 01 11

			//ReSetEidtformul();    //���ù�ʽ��Ϣ
		}else{
			$.messager.alert("��ʾ","ִ��ʧ�ܣ�ErrInfo��"+data.info) ;
		}
	},"json") ;
}
// �����ֵ�����Ѿ����ڹ�ʽ����ָ���ʽ�༭
function ReSetEidtformul()
{	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"GetExpressByCollectDrAjax",
		CollecationDr:$("#rowid").val()
	},function(data){
		if(data.ID!=""){
			$('#HaveExpFlg').val("1");   //�б��ʽ +dongkf 2015 05 06  
			/*if(data.ID==""){
				$("#WarnInfo").html("&nbsp;"+data.XStr5) ;
			}
			else{
				$("#WarnInfo").html("&nbsp;") ;
			}*/
			var obj=data;
			
			if(obj.FormulaType == "1"){
				$HUI.radio("input[name=FormulaType][value=1]").setValue(true);
			}
			if(obj.FormulaType=="3"){
				
				$HUI.radio("input[name=FormulaType][value=3]").setValue(true);
			}
			
			$("#Eidtformul").attr("tip",data.ExpressionDesc) ;
			$("#Eidtformul").html("<a>"+data.ExpressionDesc+"</a>" )  ;
			
		}else{
			$('#HaveExpFlg').val("0");   //�ޱ��ʽ +dongkf 2015 05 06
			$("#Eidtformul").attr("tip","");
			$("#WarnInfo").html("&nbsp;") ;
			$("#OldExpression").html(" ") ;
			$("#Eidtformul").html("") ;    //+dongkf 2020 01 11
		}
	},"json") ;
}


function FormulaTypeChange(e, value)
{
	//alert("this vale="+$(this).val());
	alert(value)
	if($(this).val() == "1")
	{
		alert("show")
	    $('#UseFlag').show();
		
		var tip=$("#Eidtformul").attr("tip") ;
		if((typeof tip!="undefined") && (tip!=""))
		{
			$("#Eidtformul").html("<a>"+tip+"</a>") ;
		}
	}
	else{
		$("#ClearAll").click() ;
		$("#StrategySubList").html("") ;
		$("#Eidtformul").html("") ;
		$("#UseFlag").hide();
	}
}

var CopySourceDicDr="";    //+dongkf 2015 05 06 ����Դ����Ŀ��Dr

function GrpInfoDetailGVOperate(item){
	var selected=$("#DictionaryGV").datagrid('getSelected');
	var HospitalNo=$('#hospitalNo').val();
	var InsuType=$('#insuType').val();
	var UpdateUser=session['LOGON.USERID'];
	var UseAdmType=$("#UseAdmType").combobox("getValue");
	
	if(item.text=="���Ʋ���"){
		var url=APP_PATH+"/dic.INSUQCDictionarySategySubCtl/CopyDictionarySubByIDAjax";
		//������Դ
		$.post(url,{
			hospitalNo:HospitalNo,
			insuType:InsuType,
			DictDr:selected.DictionaryDr,
			reDoFlg:0			
		},function(data){
			if(data.flag<0){
				CopySourceDicDr="";
				$.messager.alert("��ʾ",data.info);
			} 
			else{
				CopySourceDicDr=selected.DictionaryDr;   //+dongkf 2015 05 06 ����Դ��Ŀ��Dr
				$.messager.show({
					title:'��ܰ��ʾ',
					msg:data.info,
					timeout:2000,
					showType:'slide'
					,through:true
				})
			}	
		},"json")
	}
	if(item.text=="ճ������"){
		if(CopySourceDicDr==""){
			alert("û��ִ��[���Ʋ���]����������ִ�и��Ʋ�������Ŀû�ж�Ӧ�Ĳ�����ϸ��Ϣ");
			return ;
		}else{
			var selected=$("#DictionaryGV").datagrid('getSelected');
			var HospitalNo=$('#hospitalNo').val();
			var InsuType=$('#insuType').val();
			var UpdateUser=session['LOGON.USERID'];
			var UseAdmType=$("#UseAdmType").combobox("getValue");
	
			var url=APP_PATH+"/dic.INSUQCDictionarySategySubCtl/PasteDictionarySubByIDAjax";
			var ExtStr=CopySourceDicDr+"^";      //+dongkf 2015 05 06 ��չ�ַ��� ����Դ��Ŀ��Dr^
			var ExtStr=ExtStr+UseAdmType+"^"     //���ʽʹ�ó���Dr^UseAdmType^
			$.post(url,{
				hospitalNo:HospitalNo,
				insuType:InsuType,
				DictDr:selected.DictionaryDr,
				User:UpdateUser
				,ExtStr:ExtStr
				},function(data){
					if(data.flag=="-1"){
						$.messager.show({
							title:'��ܰ��ʾ',
							msg:'ճ�����Գ���'+data.info,
							timeout:2000,
							showType:'slide'
							,through:true
						});
					}else  if(data.flag=="-2"){
						$.messager.show({
							title:'��ܰ��ʾ',
							msg:'�Ѵ���',
							timeout:2000,
							showType:'slide'
							,through:true
						});
					}else{
						$.messager.show({
							title:'��ܰ��ʾ',
							msg:'������ϸ�����ɹ�',
							timeout:2000,
							showType:'slide'
							,through:true
						})
						CopySourceDicDr="";
						reloadStrategyGV('reload');
					}
				},"json");
		}
	}
}


//���ݶ��������ж���ı����ȡ��Ӧ������
function getArrDescByCode(code, objArr){
	
	var rtn=code;
	var obj=null;
	var obj,tmpCode,tmpDesc;
	var len=objArr.length;
	for(i=0;i<len;i++){
		obj=objArr[i];
		
		///2015 03 10 lilei �޸� 
		if("code" in obj){
			tmpCode=obj.code;
			if(code==tmpCode){	
				rtn=obj.desc;
				break;
			}
		}
		else if("value" in obj){
			tmpCode=obj.value;
			if(code==tmpCode){
				rtn=obj.text;
				break;
			}
		}
		
	}
	
	return rtn;
}

/// �жϵ�ǰ���õ��Ӱ�������Ƿ���Ա༭ �Ѿ����õ����õ㲻�ܱ༭
function CheckConfigActiveFlg(){
	var RtnFlg="0";
	
	var SelCommonRow=$('#DictionaryGV').datagrid('getSelected');                                            //ѡ�е���
	if (SelCommonRow!=null){
		var ConfigIndex=$('#DictionaryGV').datagrid('getRowIndex', SelCommonRow);       //ѡ�е�������
		var ConfigDesc=SelCommonRow.ConfigDesc;               //���õ���������
		var ActiveFlg=SelCommonRow.ActiveFlg;                      //���ñ�� 1 ���� 0 δ����
		if(ActiveFlg=="1"){
			var ErrMsgInfo="��:"+(ConfigIndex+1)+" ["+ConfigDesc+"] �����õ��Ѿ����ã���ͣ�ú��ٱ༭!"
			alert(ErrMsgInfo);
		}else{
			RtnFlg="1";
		}
	}else{
		alert("��ѡ��һ�����õ�����!");
	}
	
	return RtnFlg;
}

///���������������ݼ�
function reloadFactorDicDetailGV(loadType){
	var FactorDicDr=$("#FactorDicDr").val();
	//alert("FactorDicDr="+FactorDicDr);
	if(FactorDicDr==null){
		$.messager.alert("��ʾ","��ѡ�����ط����ֵ���Ϣ��")
		return
	}
	
	$('#FactorDicDetailGV').datagrid({
		url:$URL,
		queryParams: {
			ClassName:"INSU.BL.ConfigPointCtl",
			QueryName:"SearchFactorDetail",
			InputPam:FactorDicDr
		}
	});

}
