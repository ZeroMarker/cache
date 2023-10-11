$(document).ready(function(){
	//setDefaultWidth();
	//alert("$URL="+$URL);
	setLayOut();   //页面布局设置的方法
	
	regAllevent(); //事件注册方法
	bindEidtformul();
});



//解析出操作符、操作数、括号等组成的对象数组
//对象含有类型、描述、索引值等信息
//给对象数组排序后 分类型逐个解析判断
function checkExption(exption){
	var operatorArr=["&&","||","'","(",")"];            //运算符数组
	
	//01 验证括号是否匹配
	var bracketsArr = new Array();       //括号是否匹配验证用数组
	var bracketsArrLen=0;
	var tmpStr="";
	for(index=0; index<exption.length; index++){
		tmpStr=exption.substr(index,1);
		if(tmpStr=="("){
			bracketsArrLen=bracketsArr.push(tmpStr);      //括号进堆栈
		}
		if(tmpStr==")"){
			tmpStr=bracketsArr.pop();      //括号出堆栈
			if(tmpStr!="("){
				$.messager.alert("提示","公式中的括号不匹配") ;
				return false;
			}
		}
	}
	if(bracketsArr.length!=0){             //括号配对不匹配
		$.messager.alert("提示","公式中的括号不匹配") ;
		return false;
	}

	//02 将表达式解析为 运算符 括号 及操作数的数组
	//02-1 解析出运算符、括号数组
	var operatorObjArr = new Array();    //运算符以及括号的数组
	var objOperator =null;
	var tmpOpt=null;
	var expIndex=0;
	var optIndex=-1;
	var operatorNums=operatorArr.length;    //操作符数目
	for(i=0; i<operatorNums; i++){
		expIndex=0;
		tmpOpt=operatorArr[i];    //操作符
		optIndex=exption.indexOf(tmpOpt,expIndex);    //查找运算符 在表达式中的位置。
		while(optIndex>-1){
			objOperator=new Object();
			objOperator.index=optIndex;                     //索引位置
			objOperator.name=tmpOpt;                        //操作数或者运算符或者括号
			//0:操作数 1：运算符 2：括号
			if((tmpOpt=="(")||(tmpOpt==")")){
				objOperator.type="2";  //2：括号
			}else{
				objOperator.type="1";  //1：运算符
			}
			operatorObjArr.push(objOperator);
			
			expIndex=optIndex+1;
			optIndex=exption.indexOf(tmpOpt,expIndex);    //查找运算符 在表达式中的位置。
		}
	}
	
	//02-2 操作符 括号按照索引由小向大排序
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
	
	//02-3 解析出包含操作数的数组
	var optionsLen=0;
	var expObjArr = new Array();
	var expObjLen=0;
	var curretnIndex=0;
	var objOperator=null;       //操作符对象
	var operatorIndex=0;        //操作符索引
	var operatorLen=0;          //操作符长度
	var tmpLen=0;
	var objOption=null;       //操作数对象
	
	for(num=0; num<operatorArrLen; num++){
		objOperator=operatorObjArr[num];
		operatorIndex=objOperator.index;
		tmpLen=operatorIndex-curretnIndex;    //计算操作数的长度
		if(tmpLen>0){
			objOption=new Object();
			objOption.index=curretnIndex;                           //索引位置
			objOption.name=exption.substr(curretnIndex, tmpLen);    //操作数或者运算符或者括号
			objOption.type="0";                                     //操作数
			expObjLen=expObjArr.push(objOption);
			optionsLen=optionsLen+1;
		}
		expObjLen=expObjArr.push(objOperator);
		operatorLen=objOperator.name.length;       //操作符长度
		curretnIndex=operatorIndex+operatorLen;    //当前索引
	}
	
	//if(curretnIndex<(exption.length-1)){    //如果最后一位是操作数，且长度为1，操作数索引=公式长度-1
	if(curretnIndex<(exption.length)){
		objOption=new Object();
		objOption.index=curretnIndex;                           //索引位置
		objOption.name=exption.substr(curretnIndex);            //操作数或者运算符或者括号
		objOption.type="0";                                     //操作数
		expObjLen=expObjArr.push(objOption);
		optionsLen=optionsLen+1;
	}
	
	if(optionsLen==0){
		$.messager.alert("提示","公式中没有具体的规则(操作数)") ;
		return false;
	}
	
	//03 判断表达式的每一个元素是否合法
	var beforIndex, nextIndex;     //前一个元素的索引、后一个元素的索引
	var objBefor, objNext;
	var tmpObjExp =null;
	var name="";
	var type="";    //0:操作数 1：运算符 2：括号
	
	var expObjArrLen=expObjArr.length;
	//alert("expObjArr.length="+expObjArr.length);
	for(iNum=0; iNum<expObjArrLen; iNum++){
		tmpObjExp=expObjArr[iNum];
		type=tmpObjExp.type;
		name=tmpObjExp.name;
		//alert("type="+type+"||name="+name);
		//03-01 表达式开始元素的合法性判断
		if(iNum==0){
			//只能以操作数、"'"或者"("开始表达式
			if(((type=="0")||((type=="1")&&(name=="'"))||((type=="2")&&(name=="(")))==false){
				$.messager.alert("提示","公式中不能以["+name+"]开头") ;
				return false;
			}
		}
		
		//03-02 表达式结尾合法性验证
		if(iNum==(expObjArrLen-1)){
			// 只能以操作数或者")"结尾
			if(((type=="0")||((type=="2")&&(name==")")))==false){
				$.messager.alert("提示","公式中不能以["+name+"]结尾") ;
				return false;
			}
		}
		
		//03-03 表达式中运算符验证
		if(type=="1"){
			beforIndex=iNum-1;    //前一个元素的索引
			nextIndex=iNum+1;     //后一个元素的索引
			if(nextIndex>=expObjArrLen){
				nextIndex=-1;    //没有后一个元素
			}
			
			//单目运算符以外的情况，运算符的前一个元素必须为操作数
			if(beforIndex>-1){
				objBefor=expObjArr[beforIndex];
				//单目运算符前边不能直接跟操作数闭合括号等
				if((name=="'")&&((objBefor.name==")")||(objBefor.type=="0"))){
					$.messager.alert("提示","运算符["+name+"]的前一个元素不能为["+")]") ;
					return false;
				}
				
				//双目运算符前边必须为操作数或者闭合
				if((name!="'")&&(objBefor.type!="0")&&(objBefor.name!=")")){
					$.messager.alert("提示","运算符["+name+"]的前一个元素不是操作数") ;
					return false;
				}
			}
			
			//运算符的后一个元素必须为操作数
			if(nextIndex>-1){
				objNext=expObjArr[nextIndex];
				if((objNext.type!="0")&&(objNext.name!="(")&&(objNext.name!="'")){
					$.messager.alert("提示","运算符["+name+"]的后一个元素不是操作数") ;
					return false;
				}
			}
		}
	}
	
	return true;
}


///******************************************************************
///功能说明：
///          设置布局组件
///******************************************************************
function setLayOut(){

	///增加策略页面的策略关键字输入框
	$('#strategykeySearchmain').searchbox({
		prompt : '根据因素关键字添加',
		searcher : function (value, name) {
			StrategyAddFunction('1');
		}
	});
	
	$('#strategykeySearch').searchbox({
		prompt : '根据因素关键字查询',
		searcher : function (value, name) {
		reloadAddStrategyGV('load');
		}
	});

	
	setDictionaryGV();
	
	setDictionaryInfo();
	//策略明细追加
	setAddDictionary();
	
	
	
	
	$('#keywordIn').searchbox({
		prompt : '请输入关键字',
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
			"desc":"集合数据"
		},{
			"code":"1",
			"desc":"固定值",
			"selected":true
		},{
			"code":"2",
			"desc":"数据区间"
		}]
	});
	*/
	
	
	$("#ProActiveFlg").combobox({
		valueField:'value',
		textField:'text',
		data:[{
			'value':'1',
			'text':'有效',
			'selected':true
		},{
			'value':'0',
			'text':'无效'
		}]
	});
			
	$("#FDetaiActiveFlg").combobox({
		valueField:'value',
		textField:'text',
		data:[{
			'value':'1',
			'text':'有效',
			'selected':true
		},{
			'value':'0',
			'text':'无效'
		}]
	});

	//配置点启用标志
	$("#ConfigActiveFlg").combobox({
		valueField:'value',
		textField:'text',
		data:[{
			'value':'1',
			'text':'启用'
		},{
			'value':'0',
			'text':'未启用'
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
	
	setEditCommonArea();   //备注信息编辑
}

///+dongkf 2017 04 27 表达式使用场景扩展内容增加 开始==========================================
/// 功能说明：设置表达式使用场景的扩展下拉框内容
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
	///获取医保类型
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
		
		setExpUseAdmTypeDo(ExpUserTypeArr);    //设置下拉框内容
	},"json") ;
}

function setExpUseAdmTypeDo(ExpUserTypeArr){
	$('#UseAdmType').combobox({
		valueField:'code',
		textField:'desc',
		data:ExpUserTypeArr
		,onSelect:function(record){
			ReSetEidtformul();           //表达式区域
			LoadStrategySubList();       //策略操作数区域
		}
	});
}
///+dongkf 2017 04 27 表达式使用场景扩展内容增加 结束==========================================

//+dongkf 2016 03 15 start
function setFindByCateInfo(hospitalNo,insuType){
	//只取有效诊断
	var url=APP_PATH+"/dic.INSUQCDicStrategyCateCtl/FindByComboboxListAjax&hospitalNo="+hospitalNo+"&insuType="+insuType;
	$.get(url,function(data){
		$('#FindByCate').combobox('clear');
		$('#FindByCate').combobox('loadData',data.data);                    //主页面上的策略大分类
		$('#FindByCateSearch').combobox('clear');
		$('#FindByCateSearch').combobox('loadData',data.data);         //增加策略规则页面上的策略大分类
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
				$('#FindBySubCate').combobox("setValue","全部数据") ;
			}else{
				$('#FindBySubCate').combobox("setValue",DataList[0].SubCate) ;
			}*/
			$(SubCateID).combobox("setValue",DataList[0].SubCate) ;
		}
	},"json") ;
}
//+dongkf 2016 03 15 end

///******************************************************************
///功能说明：
///          进度条设置
///******************************************************************
function setProGressBar(){
	//进度条所在的窗口设置
	$('#proWin').window({
		title:'处理进度...',
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
	
	//进度条设置
	$('#progress').progressbar({
		width:386,
		height:24,
		value:0,
		onChange:function(newValue,oldValue){
			if(newValue>=100){  //处理完成后关闭进度条
				$('#proWin').window('close');
			}
		}
	});
	
	$('#proWin').window('close');
}


var FactorEditIndex = undefined ;    //因素列表当前编辑的行序号

var DataFromArray = [{
						"code":"0",
						"desc":"集合数据"
					},{
						"code":"1",
						"desc":"固定值"
					},{
						"code":"2",
						"desc":"数据区间"
					}];

var AuditFlgOption = [{
						"code":"0",
						"desc":"未审核"
					},{
						"code":"1",
						"desc":"已审核"
					},{
						"code":"2",
						"desc":"已拒绝"
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
		//singleSelect:false,       //+dongkf 2019 12 03  增加checkbox 后可以支持多选
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
			{field:'FactorCode',title:'分类编码',width:70,hidden:'true'},
			{field:'FactorDesc',title:'因素分类',width:80},
			{field:'FactorName',title:'因素名称',width:150,editor:{type:'text'}
				,styler: function(value,row,index){
					var rtnStyle="";
					if(row.AuditFlg=="1"){
						rtnStyle= 'background-color:#00ffff;';
					}
					return rtnStyle;
				}
			},
			
			{field:'DataFrom',title:'数据来源',width:140,
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
			{field:'CompareVal',title:'固定值',width:145,editor:{type:'combobox'}},
			{field:'CompareNM',title:'固定值名称',width:105},
			{field:'CompareStartVal',title:'最小值',width:80,editor:{type:'text'}},
			{field:'CompareEndVal',title:'最大值',width:80,editor:{type:'text'}},
			{field:'AuditFlg',title:'审核标记',width:90
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
			{field:'InputPamTag',title:'入参标记',width:130
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
			,{field:'FactorCommon',title:'因素备注',width:200}
			,{field:'CheckClsName',title:'验证类名',width:150,hidden:'true'}
			,{field:'CheckMethodName',title:'验证方法名',width:150,hidden:'true'}
			
			
			,{field:'XStr1',title:'query生成数据集标志',width:150,hidden:'true'}
			,{field:'XStr2',title:'验证类名',width:150,hidden:'true'}
			,{field:'XStr3',title:'验证类名',width:150,hidden:'true'}
		]]
		
		
		,onLoadSuccess:function(data){
			      //复选框处于选择状态         -dongkf 2019 12 03
			SetRowCheckedByAuditFlg("StrategyGV");    //单个提交修改为选择后全部提交   +dongkf 2019 12 03
			if(data.rows.length>0){
				ReSetEidtformul();
				
				LoadStrategySubList();       //策略操作数区域
			}
			
			BuildConfigPamFormat();    //组织验证入参格式
		}
		,onClickRow:function(rowIndex,rowData){
			//alert("RowID="+rowData.RowID+"||ConDataDr="+rowData.ConDataDr);
			clearTimeout(TimeFn);      ///设置延时，用于将单击事件和双击事件区分开
			TimeFn = setTimeout(function () {
				$("#StrategyGV").datagrid("beginEdit",rowIndex);
				
				if((FactorEditIndex!=undefined)&&(FactorEditIndex!=rowIndex)){
					$("#StrategyGV").datagrid("endEdit",FactorEditIndex);
				}
				
				var edmin=$('#StrategyGV').datagrid("getEditor",{'index':rowIndex,field:"CompareStartVal"}) ;         //最小值单元格编辑对象
				var edmax=$("#StrategyGV").datagrid('getEditor', { 'index': rowIndex, field: 'CompareEndVal' });    //最大值单元格编辑对象
				var edvalue=$("#StrategyGV").datagrid('getEditor', { 'index': rowIndex, field: 'CompareVal' });     //固定值单元格编辑对象
				
				
				///alert("query标记："+rowData.XStr1);
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
							SetRowEditStatus(DataFrom, edmax, edmin, edvalue, rowData);    //设置编辑状态
							//alert(DataFrom)
							/*
							if(DataFrom=="1"){    //数据来源为固定值，则区间设置不能编辑							
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
							SetRowEditStatus(rowData.DataFrom, edmax, edmin, edvalue, rowData);    //设置编辑状态
						}
					})
				}
				
				FactorEditIndex = rowIndex;
			
			}, 200);
		},
		onDblClickRow:function(rowIndex,rowData){
			clearTimeout(TimeFn);
			$('#StrategyGV').datagrid('endEdit',rowIndex);
			//初始化因素明细数据
			$('#CofingFactorDr').val("");
			$('#queryflg').val("");
			$('#ProCode').val("");
			$('#ProName').val("");
			$('#ProValue').val("");
			$('#ProActiveFlg').combobox('setValue', "1");
			
			var DataFrom = rowData.DataFrom;     //数据来源  0 数据集  1 固定值  2 数据区间
			if(DataFrom=="0"){           //数据集在弹窗中修改
				$("#CofingFactorDr").val(rowData.ConDataDr)
				var queryflg=rowData.XStr1;   //query 查询标记
				var className=rowData.XStr2;   //query类名
				var QueryName=rowData.XStr3;  //query方法名
				if((queryflg=="1")&&(className!="")&&(QueryName!="")){
					$("#ProCode").hide();        //如果有query查询的数据，则显示下拉框，在下拉框中选择需要维护的数据，否则在文本框中手工输入数据
					$("#ProCodeCombo").show();
					
					$('#ProCodeCombo').css('display','none');
					$("#queryflg").val("1");    //query查询数据标记
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
					//$HUI.combobox('#ProCodeCombo','clear');    //清空
				}else{
					$("#ProCode").show();        //如果有query查询的数据，则显示下拉框，在下拉框中选择需要维护的数据，否则在文本框中手工输入数据
					$("#ProCodeCombo").hide();
					$("#queryflg").val("0");
				}
				
				$('#Edit_ConfigMap_Area').window("open");
			}
			/*
			else{           //固定值及数据区间直接在策略行编辑
				if((FactorEditIndex!=undefined)&&(FactorEditIndex!=rowIndex)){
					$("#StrategyGV").datagrid("endEdit",FactorEditIndex);
				}
				$("#StrategyGV").datagrid("beginEdit",rowIndex);
				if(DataFrom=="1"){    //数据来源为固定值，则区间设置不能编辑
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
					$.messager.alert("提示","服务器发生错误！"+data.info) ;
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
	
	/// 增加策略页面的策略展示列表
	$('#AddStrategyGV').datagrid({
		//title: '知识库策略明细',
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
			{field:'FactorCode',title:'因素编码',width:115,sortable:'true'},
			{field:'FactorDesc',title:'因素描述',width:120},
			{field:'InputPamTag',title:'入参标记',width:130
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
			{field:'EditFlg',title:'双击编辑',width:85
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
				 		rtn="可双击";
				 	}else{
				 		rtn="";
				 	}
				 	return rtn;
				}
			},
			//{field:'DataFrom',title:'数据来源',width:100,hidden:'true'},
			{field:'XStr1',title:'query生成标记',width:100,
				formatter:function(value,row){
				 	var rtn="";
				 	if(value=="1"){
				 		rtn="是";
				 	}else{
				 		rtn="否";
				 	}
				 	return rtn;
				}
			},
			{field:'XStr2',title:'query类名',width:200},
			{field:'XStr3',title:'query方法名',width:150},
			{field:'FactorCommon',title:'因素备注',width:120},
			{field:'CheckClsName',title:'验证类名',width:100},
			{field:'CheckMethodName',title:'验证方法名',width:100}
			]
		],
		onClickRow:function(index, rowData){
			clearTimeout(TimeFactorDicFn);      ///设置延时，用于将单击事件和双击事件区分开
			TimeFactorDicFn = setTimeout(function () {
				var Flag=$('#AddStrategyGV').parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(':checked');
				if(Flag){
					$('#AddStrategyGV').datagrid('uncheckRow',index);
					$(this).datagrid('unselectRow', index); 
				}else{
					$('#AddStrategyGV').datagrid('checkRow',index);
					$(this).datagrid('selectRow', index); 
					$('#AddStrategyGV').parent().find(".datagrid-body .datagrid-btable tbody").children("tr").eq(index).addClass("SelectedRowRecStyle");     //设置当前行的高亮显示
					
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
				clearFactorDicDetailEdit();   //清空编辑区域
				//alert("rowData.RowID="+rowData.RowID);
				$("#FactorDic_Details_Area").window("open");
			}
		},
		onLoadSuccess:function(data){
			//加载完成后将选中的配置点关联的元素默认勾选
			/*
			var SelFactorRows=$("#StrategyGV").datagrid("getRows");
			var data=$("#AddStrategyGV").datagrid("getRows");			
			for(var index=0;index<data.length;index++){      //所有元素
				var Factor=data[index];
				var FactorCode=Factor.FactorCode;    //元素列表				
				for(var Selindex=0;Selindex<SelFactorRows.length;Selindex++){     //配置点关联的元素
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
			{field:'ProCode',title:'配置元素编码',width:100},
			{field:'ProName',title:'配置元素名称',width:160},
			{field:'ProValue',title:'配置元素可选值',width:120},
			{field:'ActiveFlg',title:'有效标记',width:100
				,formatter:function(value,row){
					var rtn="";
					if(value=="1"){
						rtn="有效";
					}else{
						rtn="无效";
					}
					return rtn;
				}
			},
			{field:'UpdateUser',title:'操作员',width:100},
			{field:'UpdateDate',title:'更新日期',width:100},
			{field:'UpdateTime',title:'更新时间',width:100}
			]
		],
		onClickRow:function(rowIndex,rowData){
			setEditConfig(rowData);
		}
	});
	
	//影响因素可选值范围维护
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
			{field:'ProCode',title:'可选值编码',width:100},
			{field:'ProName',title:'可选值名称',width:160},
			{field:'ProValue',title:'可选值',width:120},
			{field:'ActiveFlg',title:'有效标记',width:100
				,formatter:function(value,row){
					var rtn="";
					if(value=="1"){
						rtn="有效";
					}else{
						rtn="无效";
					}
					return rtn;
				}
			},
			{field:'UpdateUser',title:'操作员',width:100},
			{field:'UpdateDate',title:'更新日期',width:100},
			{field:'UpdateTime',title:'更新时间',width:100},
			{field:'FactorCode',title:'因素编码',width:100},
			{field:'FactorDesc',title:'因素描述',width:100}
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

/// 清空影响因素编辑页面的编辑区域值
function clearFactorDicDetailEdit(){
	$('#FactorDetailDr').val("");
	$('#FDetailCode').val("");
	$('#FDetailName').val("");
	$('#FDetaiValue').val("");
	$('#FDetaiActiveFlg').combobox('setValue', '1');
}

function SetRowEditStatus(DataFrom, edmax, edmin, edvalue, rowData){
	if(DataFrom=="1"){    //数据来源为固定值，则区间设置不能编辑							
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

//根据配置的因素生成 验证需要的xml参数格式
function BuildConfigPamFormat(){
	$("#inputPamInfo").html("") ;    //清空原来的公式
		
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
		var FactorCode="";         //因素字典编码
		var FactorDesc="";         //因素字典名称
		var InputPamTag="";     //入参标记
		var NodeTagArr=[];
			
		for(var i=0 ; i < Len ; i++ )
		{
			var Data=DataRows[i] ;
			AuditFlg=Data.AuditFlg;     //审核标记
			if(AuditFlg !="1") { continue; }
			FactorCode=Data.FactorCode;
			FactorDesc=Data.FactorDesc;
			InputPamTag=Data.InputPamTag;
			if(InputPamTag==""){
				InputPamTag=FactorCode;
			}
			if(NodeTagArr.indexOf(InputPamTag) != -1){   //已经存在的场合 跳过
				continue;
			}
			
			PamNode="<"+InputPamTag+">"+FactorDesc+"</"+InputPamTag+">";    //构造单个因素的
			if(PamNodes==""){
				PamNodes=PamNode;
			}else{
				PamNodes=PamNodes+PamNode;
			}
			NodeTagArr.push(InputPamTag);    //已经生成过的参数 加入到数组中
		}
	}

	var ConfigNode="<ConfigCode>业务配置点</ConfigCode>";
	var InputPamInfo="<Input>"+ConfigNode+PamNodes+"</Input>";
	$("#inputPamInfo").text(InputPamInfo);
}

/// 功能说明：根据审核状态设置当前
function SetRowCheckedByAuditFlg(StrategyGV){
	var objRow=null;
	var AuditFlg="0";
	var rowRecs=$('#'+StrategyGV).datagrid('getRows');
	var rowLen=rowRecs.length;                             //总行数
	for (i=0; i<rowLen; i++){
		objRow=rowRecs[i];        //当前行数据
		AuditFlg=objRow.AuditFlg;        //已审核标记
		if(AuditFlg=="1"){
			$('#'+StrategyGV).datagrid('checkRow', i);
		}else{
			$('#'+StrategyGV).datagrid('uncheckRow', i);
		}
	}
}

///******************************************************************
///功能说明：
///          使审核复选框处于可编辑状态,并注册事件
///******************************************************************
function setStrateEditStatis(EditFlg){
	var rowRecs=$('#StrategyGV').datagrid('getRows');
	var rowLen=rowRecs.length;                             //总行数
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

/// 审核复选框点击事件
function SingeStrateAuditCheckClick(e){
	var AuditTarget=e.target;
	var RowIndex=$(AuditTarget).parents(".datagrid-row").attr("datagrid-row-index");    //所在行索引
	
	$('#StrategyGV').datagrid('endEdit', RowIndex);
	var DataRows=$('#StrategyGV').datagrid('getRows');     //当前页的所有数据
	var RowData=DataRows[RowIndex];                              //当前行数据
	//alert("RowIndex="+RowIndex);
	//UpdateCommonInfo(0, 1, RowData, "0")                       //更新本行数据
	UpdateStrategyInfo(RowIndex, 1, RowData, LgUserID,"0");     //逐条审核
}

///******************************************************************
///功能说明：
///          单击策略明细时，设置为可编辑状态
///******************************************************************
var editIndex=undefined;
function StrategyGVonClickRow(index, rowData){

	//设置编辑行
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
///功能说明：
///          将正在修改的行数据状态改为已经修改完成
///******************************************************************
function endEditRow(){
	$("#StrategyGV").datagrid('endEdit', editIndex);
	editIndex = undefined;
}

///******************************************************************
///功能说明：
///          设置知识库一览区域
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
			{field:'ConfigCode',title:'配置点编码',width:150},
			{field:'ConfigDesc',title:'配置点名称',width:200
				,styler: function(value,row,index){
					var rtnStyle="";
					if(row.ActiveFlg=="1"){
						rtnStyle= 'background-color:#00ffff;';
					}
					return rtnStyle;
				}
			},
			{field:'ActiveFlg',title:'启用标志',width:80
				,formatter:function(value,row){
					var rtn = "";
					if(value=="1"){
						rtn="启用";
					}else{
						rtn="未启用";
					}
					
					return rtn;
				}
			},
			{field:'UpdateUser',title:'操作员',width:100},
			{field:'UpdateDate',title:'更新日期',width:100},
			{field:'UpdateTime',title:'更新时间',width:100},
			{field:'ConfigCommon',title:'备注',width:250},
			{field:'XStr1',title:'备用1',width:150, hidden:true},
			{field:'XStr2',title:'备用2',width:150, hidden:true},
			{field:'XStr3',title:'备用3',width:150, hidden:true},
			{field:'XStr4',title:'备用4',width:150, hidden:true},
			{field:'XStr5',title:'备用5',width:150, hidden:true},
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
			DictionaryStrategyInfoClear();    //策略明细区域初始化
			
			//setItmEditStatis("1");    //复选框处于选择状态
			//SetRowCheckedByAuditFlg("DictionaryGV");    //单个提交修改为选择后全部提交   +dongkf 2019 12 03
		}
		,loadFilter: function(data){
			if("status" in data)
			{
				if(data.status<0)
				{
					$.messager.alert("提示","服务器发生错误！"+data.info) ;
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
///功能说明：
///          使审核复选框处于可编辑状态,并注册事件
///******************************************************************
function setItmEditStatis(EditFlg){
	var rowRecs=$('#DictionaryGV').datagrid('getRows');
	var rowLen=rowRecs.length;                             //总行数
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

/// 审核复选框点击事件
function SingerAuditCheckClick(e){
	var AuditTarget=e.target;
	var RowIndex=$(AuditTarget).parents(".datagrid-row").attr("datagrid-row-index");    //所在行索引
	
	$('#DictionaryGV').datagrid('endEdit', RowIndex);
	var DataRows=$('#DictionaryGV').datagrid('getRows');   //当前页的所有数据
	var RowData=DataRows[RowIndex];                              //当前行数据
	UpdateCommonInfo(0, 1, RowData, "0")                       //更新本行数据
}

/// 选择备注行
function SelectedCommonRow(index, rowData){
	DicItmSelIndex=index;
	setDictionaryDetail(index, rowData);   //设置知识库明细部分类容
}

function FormulaClear(){
	
	//表达式编辑信息清空
	$("#rowid").val();
	$("#StrategySubList").html("") ;
	$("#Eidtformul").html("") ;
	$("#ClearAll").click() ;
	$('#UseAdmType').combobox('setValue','C');
	$("input[name=FormulaType][value=2]").click();
	//$('#UseAdmType').val("")
	
	//endEditRow();                        //编辑状态取消
	//reloadStrategyGV('load');            //策明细清空略
	
	
}

///******************************************************************
///功能说明：
///          用选择的知识库行，填充知识库明细内容部分
///******************************************************************
function setDictionaryDetail(index, rowData)
{

	$('#rowid').val(rowData.RowID);                 //选择的项目Dr
	//$('#ItmCode').val(rowData.CommonCode);       //选择的项目编码
	//$('#ItmDesc').val(rowData.CommonEdit);        //选择的项目名称

	//reloadStrategyGV('load');  //策略明细加载
}


///******************************************************************
///功能说明：
///          事件注册方法
///******************************************************************
function regAllevent(){
	
	// 增加一条策略明细
	$('#StrategyAdd').on('click',function(){
		StrategyAddFunction("0");
	});
	
	// 删除一条策略明细
	$('#StrategyRemove').on('click',StrategyRemoveFunction);
	
	// 增加策略明细对应的事件
	regAddDictionaryEvent();
	
	//知识库数据导入(新) //+dongkf 2019 07 18
	$("#FactorImprot").on("click", function(){
		var UserDr=session['LOGON.USERID'];
		var GlobalDataFlg="0";                          	 //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
		var ClassName="INSU.BL.ConfigPointCtl";                     //导入处理类名
		var MethodName="ImportConfigFactorByExcel";          //导入处理方法名
		var ExtStrPam="";                                                        //备用参数()
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
	});
	
	/// 导入备注信息
	$("#CommonImprot").on("click", function(){
		var UserDr=session['LOGON.USERID'];
		var GlobalDataFlg="0";                          	 //是否保存到临时global的标志 1 保存到临时global 0 保存到表中(必须有类名和方法名)
		var ClassName="INSU.BL.ConfigPointCtl";                     //导入处理类名
		var MethodName="ImportConfigPointByExcel";          //导入处理方法名
		var ExtStrPam="";                                                        //备用参数()
		ExcelImport(GlobalDataFlg, UserDr, ClassName, MethodName, ExtStrPam);
	});
	
	///维护备注信息 
	$("#open_edit_win").on("click", function(){
		$('#Edit_Common_Area').window("open");
	});
	
	$("#open_factor_edit_win").on("click", function(){
		$('#Edit_Factor_Area').window("open");
	});
	
	/// 清空编辑区域
	$("#ClearEdit").on("click", ClearCommonEditArea);
	
	/// 保存限制信息
	$("#SaveCommon").on("click", SaveCommonInfo);
	
	//保存因素字典信息
	$("#SaveFactor").on("click", SaveDicFactorInfo);
	
	//删除因素字典信息
	$('#DeleteFactor').on("click", function(){
		var DataDr=$('#SelFactorDr').val();
		if(DataDr=="") { return 0;}
		$.messager.confirm("删除", "确定删除本条数据?", function (r) {
			if (r) {
				DeleteDicFactorInfo();
			} 
		});
	});
	
	//清空因素编辑区域
	$("#ClearFactor").on("click",ClearFactorArea);
	
	// 删除备注信息
	$("#DeleteCommon").on("click", function(){
		var CommonDr=$('#SelCommonDr').val();
		if(CommonDr=="") { return 0;}
		$.messager.confirm("删除", "确定删除本条数据?", function (r) {
			if (r) {
				DeleteCommonInfo();
			} 
		});
	});
	
	
	///删除配置点和因素的关联关系
	$("#DeletConFactorBtn").on("click", function(){
		if(CheckConfigActiveFlg()!="1"){    //是否可以编辑验证
			return 0;
		}
		
		var SelConFac = $("#StrategyGV").datagrid("getSelected");
		if(SelConFac==null){
			$.messager.alert("提示","未选中需要删除的因素");
			return;
		}
		$.messager.confirm("删除", "确定删除本条数据?", function (r) {
			if (r) {
				DeletConFactor();
			} 
		});
	});
	
	///配置因素审核提交
	$("#AuditChangeCommit").on("click",AuditChangeCommitFunction);
	
	///保存因素配置数据集
	$("#addFacotrPro").on("click",SaveFactorConfigInfo);
	$("#FDetaiAddBtn").on("click",FDetaiAddBtnFun);
	
	$("#DelFactorPro").on("click",DeletFactorConfig);
	$("#FDetaiDelBtn").on("click",FDetaiDelBtnFun);
	$("#FDetaiClearBtn").on("click",function(){
		clearFactorDicDetailEdit();
	});
	
	/// 本页 备注审核处理事件注册
	$("#ItmCom_Audit_Btn").on("click", ItmCommonAudit);
	
	/// 本页 备注审核取消
	$("#ItmCom_AuditC_Btn").on("click", ItmCommonAuditC);
	
	// 审核状态改变的项目审核提交
	$("#ItmCom_AuditChange_Btn").on("click", ItmCommonAuditChange);
	
	///数据集手工维护或querey查询标记
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

	/// 本页 备注审核取消
function ItmCommonAuditC(){
	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#DictionaryGV').datagrid('getRows');                   //本页所有数据
	var AllRowLen=AllrowRecs.length;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		if(objRowTmp.AuditFlg =="1"){
			rowRecs.push(objRowTmp);
		}
	}
	
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateCommonInfo(0, rowLen,rowRecs, "2");     //逐条取消审核备注信息
	}else{
		$.messager.show({
			title:'温馨提示',
			msg:'当前没有需要提交的审核信息',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

/// 审核状态修改的记录审核提交
function ItmCommonAuditChange(){
	
	var CheckedIndexArr=GetCheckedRowIndexArr("DictionaryGV");    //选择行的索引数组
	
	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#DictionaryGV').datagrid('getRows');                   //本页所有数据
	var AllRowLen=AllrowRecs.length;
	var AuditFlg="";
	var CheckedFlg=-1;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		AuditFlg=objRowTmp.AuditFlg;       //审核状态
		CheckedFlg=CheckedIndexArr.indexOf(index);          //当前行是否被选中  负数为非选中  正数为选中
		if((AuditFlg=="1")&&(CheckedFlg<0)||(AuditFlg !="1")&&(CheckedFlg>=0)){    //只选择已经修改了审核状态的数据
			rowRecs.push(objRowTmp);
		}
	}
	
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateCommonInfo(0, rowLen,rowRecs, "3");     //逐条审核备注信息
	}else{
		$.messager.show({
			title:'温馨提示',
			msg:'当前没有需要提交的审核信息',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

///备注审核处理事件注册
function ItmCommonAudit(){

	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#DictionaryGV').datagrid('getRows');                   //本页所有数据
	var AllRowLen=AllrowRecs.length;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		if(objRowTmp.AuditFlg !="1"){
			rowRecs.push(objRowTmp);
		}
	}
	
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateCommonInfo(0, rowLen,rowRecs, "1");     //逐条审核备注信息
	}else{
		$.messager.show({
			title:'温馨提示',
			msg:'当前没有需要提交的审核信息',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

// DoType --> 0 单条数据更新 1 本页审核通过
function UpdateCommonInfo(i, len, rowRecs, DoType){
	var objCommonInfo=null;
	if(DoType=="0"){     //单条数据
		objCommonInfo=rowRecs;
	}
	
	if((DoType=="1")||(DoType=="2")){    //本页审核通过 所以是多条
		objCommonInfo=rowRecs[i];
	}

	if(DoType=="3"){     //审核状态改变的项目审核提交
		objCommonInfo=rowRecs[i];
		var tmpAuditFlg=objCommonInfo.AuditFlg;      //审核标志
		if(tmpAuditFlg=="1"){
			tmpAuditFlg="0";
		}else{
			tmpAuditFlg="1";
		}
		objCommonInfo.AuditFlg=tmpAuditFlg;      //审核标志
	}
	
	var CommonDesc=objCommonInfo.CommonDesc;                       //限制信息描述
	var CommonEdit=objCommonInfo.CommonEdit;                         //限制信息名称
	var AuditFlg=objCommonInfo.AuditFlg;                                       //审核标志
	if (DoType =="1" ) {  //本页审核通过
		AuditFlg="1"; 
	}
	if(DoType=="2") {
		AuditFlg="0"; 
	}
	
	var RowDataInfo=CommonDesc+"^"+CommonEdit+"^"+AuditFlg;
	var CommonDr=objCommonInfo.RowID;                                      //限制信息Dr
	var RowIndex=$('#DictionaryGV').datagrid('getRowIndex', objCommonInfo);       //选中的行索引
		
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
					if(index<len){     //判断是否更新完毕
						UpdateCommonInfo(index,len,rowRecs, DoType);
					}else{
						if((DoType=="1")||(DoType=="2")||(DoType=="3")){
							reloadDictionaryGV('reload');
							alert("审核完成!");
						}else{ //单条审核过后 更新页面
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
				$.messager.alert('系统错误','系统异常，请稍后重试');
			}
		},
		'json'
	);
}

///删除配置点信息
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
				
				reloadDictionaryGV('reload');   //重新加载数据
				ClearCommonEditArea();         //清空编辑区域
				$.messager.show({
					title:'提示',
					msg:'删除成功',
					timeout:2000,
					showType:'slide'
					,through:true
				});
			}else{
				$.messager.alert("错误提示","删除失败："+data.info);
			}
		},
		'json'
	);
}

/// 保存备注限制信息
function SaveCommonInfo(){
	var ConfigCode=$('#ConfigCode').val();                       //限制信息描述
	if(ConfigCode==""){
		alert("配置点编码不能为空");
		return 0;
	}
		
	var ConfigDesc=$('#ConfigDesc').val();                         //限制信息名称
	if(ConfigDesc==""){
		alert("配置点描述不能为空");
		return 0;
	}
	
	var ConfigCommon=$('#ConfigCommon').val();          //备注
	
	var ConfigActiveFlg=$('#ConfigActiveFlg').combobox('getValue') ;      //启用标志
	var HospitalNo=$('#HospitalNo').combobox('getValue') ;                    //医院编码
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
					$('#DictionaryGV').datagrid('selectRow', tmpIndex);             //选择最后一行
					$('#SelCommonDr').val(data.Status);                                   //设置当前选择数据的Dr
					$('#SelCommonIndex').val(tmpIndex);                                //设置当前选择的索引
				}
			}
			SelectedCommonRow(tmpIndex, data.Data);    //选择事件
			*/
			reloadDictionaryGV('reload');
			
			$.messager.show({
				title:'提示',
				msg:'保存成功',
				timeout:2000,
				showType:'slide'
				,through:true
			});
		}else{
			$.messager.alert("提示","保存失败："+data.info);
		}
		
	});
}

/// 保存影响因素字典信息
function SaveDicFactorInfo(){
	var ErrMsgInfo="";
	var FactorCode=$('#FactorCode').val();
	if(FactorCode==""){
		ErrMsgInfo=ErrMsgInfo+"因素编码不能为空!\n";
	}
	var FactorDesc=$('#FactorDesc').val();
	if(FactorDesc ==""){
		ErrMsgInfo=ErrMsgInfo+"因素描述不能为空!\n";
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
			reloadAddStrategyGV('reload');   //重新加载数据
			ClearFactorArea();         //清空编辑区域
			$.messager.show({
				title:'提示',
				msg:'保存成功',
				timeout:2000,
				showType:'slide'
				,through:true
			});
		}else{
			alert(data.info);
		}
		
	});
}

// 删除因素字典信息
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
				
				reloadAddStrategyGV('reload');   //重新加载数据
				ClearFactorArea();         //清空编辑区域
				$.messager.show({
					title:'提示',
					msg:'删除成功',
					timeout:2000,
					showType:'slide'
					,through:true
				});
			}else{
				$.messager.alert("错误提示","删除失败："+data.info);
			}
		},
		'json'
	);
}

/*
// 策略库维护
function StrategyEditewinFunction(){
	
	$('#Strategywin iframe').attr("src","../../pages/dictionmanger/dictionarystrategy.csp?hospitalNo="+$('input[name=hospitalNo]').val()+"&insuType="+$('input[name=insuType]').val());
	$('#Strategywin').window("open");
}

// 知识库维护
function DictionaryEditewinFunction(){
	$('#Dictionarywin iframe').attr("src","../../pages/dictionmanger/dictionary.csp?hospitalNo="+$('input[name=hospitalNo]').val()+"&insuType="+$('input[name=insuType]').val());
	$('#Dictionarywin').window("open");
}
*/

///******************************************************************
///功能说明：
///         无策略知识库对应的策略解析
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
					title:'温馨提示',
					msg:data.info,
					timeout:2000,
					showType:'slide'
					,through:true
				});
				
				
			}else{
				$('#proWin').window('close');
				$.messager.alert('系统错误','系统异常，请稍后重试');
			}
		},
		'json'
	);
}

///******************************************************************
///功能说明：
///          本页审核取消
///******************************************************************
function updateCommitFunctionC(){
	//endEditRow();
	var userID=LgUserID;              //用户ID
	
	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#StrategyGV').datagrid('getRows');                   //本页所有数据
	var AllRowLen=AllrowRecs.length;
	for(index=0; index<AllRowLen; index++){
		objRowTmp=AllrowRecs[index];
		if(objRowTmp.AuditFlg =="1"){   //取得已审核的数据
			rowRecs.push(objRowTmp);
		}
	}
	
	//var rowRecs=$('#StrategyGV').datagrid('getChanges','updated');
	var rowLen=rowRecs.length;
	if(rowLen>0){
		UpdateStrategyInfo(0,rowLen,rowRecs,userID,"2");     //逐条审核取消
	}else{
		$.messager.show({
			title:'温馨提示',
			msg:'当前没有修改的策略审核信息',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

///******************************************************************
///功能说明：
///          修改提交按钮方法
///******************************************************************
function updateCommitFunction(){
	//endEditRow();
	var userID=LgUserID;              //用户ID
	
	var rowRecs=[];
	var objRowTmp=null;
	var AllrowRecs=$('#StrategyGV').datagrid('getRows');                   //本页所有数据
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
		UpdateStrategyInfo(0,rowLen,rowRecs,userID,"1");     //逐条审核
	}else{
		$.messager.show({
			title:'温馨提示',
			msg:'当前没有修改的策略审核信息',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

/// 审核提交按钮事件方法
function AuditChangeCommitFunction(){
	//var userID=LgUserID;              //用户ID
	//alert("FactorEditIndex="+FactorEditIndex);
	
	if(CheckConfigActiveFlg()!="1"){    //是否可以编辑验证
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

/// 功能说明：验证因素维护数据是否完整
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
			FactorDesc=objRow.FactorDesc;                     //因素分类
			FactorName=objRow.FactorName;                 //因素名称
			DataFrom=objRow.DataFrom;                        //数据来源
			CompareVal=objRow.CompareVal;                 //固定值
			CompareStartVal=objRow.CompareStartVal;   //最小值
			CompareEndVal=objRow.CompareEndVal;     //最大值
			indexName="第"+(index+1)+"行:";
			ErrMsgTmp="";
			if(FactorName==""){
				ErrMsgTmp="因素名称不能为空!";
			}
			if((DataFrom=="1")&&(CompareVal=="")){     //0 集合数据 1 固定值  2 数据区间
				ErrMsgTmp=ErrMsgTmp+"数据类型为固定值的场合，固定值不能为空!";
			}
			if((DataFrom=="2")&&((CompareStartVal=="")&&(CompareEndVal==""))){     //0 集合数据 1 固定值  2 数据区间
				ErrMsgTmp=ErrMsgTmp+"数据类型为[数据区间]的场合，最大值和最小值不能同时为空!";
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
		alert("没有需提交的数据!");
	}
	
	return RtnFlg;
}


/// 获取列表中被选择行的索引数组
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
///功能说明：
///          增加策略按钮方法
///******************************************************************
function StrategyAddFunction(SearchFlg){
	//alert("StrategyAddFunction");
	//endEditRow();
	//$('#StrategyGV').datagrid('appendRow',{status:'P'});
	//clearDicStrategyDetail();
	
	/*
	var detailUserId=$('input[name=userId]').val();              //用户ID
	var detailHostpitalNo=$('input[name=hospitalNo]').val();
	var detailInsuType=$('input[name=insuType]').val();
	$('#dicId').val(dicId);                                 //知识库ID
	$('#detailUserId').val(detailUserId);                   //用户ID
	$('#detailHostpitalNo').val(detailHostpitalNo);         //医院编码
	$('#detailInsuType').val(detailInsuType);               //医保类型
	*/
	
	$('#AddStrategyGV').datagrid('loadData',{total:0,rows:[]});           //查询页面初始化
	if(SearchFlg=="1"){
		$('#AddOpenMode').val("1");     //打开模式  0 普通打开  1 检索打开
		
		var strategykeySearchm=$('#strategykeySearchmain').searchbox('getValue');                          //中心词关键字
		$('#strategykeySearch').searchbox('setValue', strategykeySearchm);
		reloadAddStrategyGV('load');
	}else{
		$('#strategykeySearch').searchbox('setValue', "");
		$('#AddOpenMode').val("0");     //打开模式  0 普通打开  1 检索打开
	}
	
	var dicId=$('#rowid').val();
	if(dicId!=""){
		$('#addDictionary').window("open"); 
	}else{
		$.messager.show({
			title:'温馨提示',
			msg:'请选择知识库信息',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}


///******************************************************************
///功能说明：
///          策略删除按钮方法
///******************************************************************
function StrategyRemoveFunction(){
	endEditRow();
	
	var rowRecs=$('#StrategyGV').datagrid('getSelections');
	var rowLen=rowRecs.length;
	if(rowLen==1){
		var HaveExpFlg = $('#HaveExpFlg').val();   //有表达式 +dongkf 2015 05 06  
		if(HaveExpFlg==1){
			alert('含有公式，暂时不能删除!');
			/*-dongkf 2019 11 20  这里有可能还需要修改
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
			title:'温馨提示',
			msg:'请选择一行数据',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

///******************************************************************
///功能说明：
///          项目库包含有表达式的策略明细删除操作
///版本履历：dongkf 2015 05 07
///******************************************************************
function StrategyRemoveExeHasExp(rowRecs,DicItmDr,DicSubDr,ExtStr){
	var Url=APP_PATH+"/dic.INSUQCDictionarySategySubCtl/DeleteSategySubCheck";   //包含有表达式的项目，需要判断表达式是否包含当前的策略
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
					$.messager.alert('温馨提醒',data.info);
				}
			}else{
				$.messager.alert('系统错误','系统异常，请稍后重试');
			}
		},
		'json'
	);
}

///******************************************************************
///功能说明：
///          策略明细删除操作
///版本履历：dongkf 2015 05 07
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
							title:'温馨提示',
							msg:'策略删除成功！',
							timeout:2000,
							showType:'slide'
							,through:true
						});
					}else{
						$.messager.alert('更新失败','审核信息更新失败，详细信息：'+data.rtnMsg);
					}
				}else{
					$.messager.alert('系统错误','系统异常，请稍后重试');
				}
			},
			'json'
		);
}

///******************************************************************
///功能说明：
///          策略再解析按钮方法
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
			title:'温馨提示',
			msg:'请选择一条知识库数据',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}

}

///******************************************************************
///功能说明：
///          策略明细全部审核通过按钮方法
///******************************************************************
function StrategySaveAllFunction(){
	endEditRow();
	var userID=$('input[name=userId]').val();              //用户ID
	var rowRecs=$('#StrategyGV').datagrid('getRows');
	var rowLen=rowRecs.length;                             //总行数
	if(rowLen>0){
		UpdateStrategyInfo(0,rowLen,rowRecs,userID,"0");   //保存审核结果
		$('#proWin').window('open');
	}else{
		$.messager.show({
			title:'温馨提示',
			msg:'没有需要审核的策略明细信息',
			timeout:2000,
			showType:'slide'
			,through:true
		});
	}
}

///******************************************************************
///功能说明：
///          检索按钮事件方法
///******************************************************************
function searchDictionaryInfo(){
	reloadDictionaryGV('load');
	/// 获取策略等级和后台控制等级
	var hospitalNo=$('#hospitalNo').val();
	var insuType=$('#insuType').val();
	var data={
		hospitalNo:hospitalNo
		,insuType:insuType
	};
	
	//策略等级
	$.get(
		APP_PATH+"/dic.INSUQCStrategyLevelCtl/getComboboxListAjax&hospitalNo="+hospitalNo+"&insuType="+insuType
		,function(data){
			StrategyArrLevel=data.data ;
		}
		,"json"
	);
	
	//控制等级
	$.get(
		APP_PATH+"/dic.INSUQCControlLevelCtl/getComboboxListAjax&hospitalNo="+hospitalNo+"&insuType="+insuType
		,function(data){
			ControlLevel=data.data ;
		}
		,"json"
	);

	//控制等级
	$.get(
		APP_PATH+"/com.INSUQCDicDataCtl/dicTypeList&dicType=Strategy_UseType"
		,function(data){
			data=comboboxLoadFilter(data);    //判断后台数据是否出现错误
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
///功能说明：
///          逐条更新审核结果
///参数说明：DoType --> 0 单条数据更新 1 本页审核通过  2 本页审核取消
///******************************************************************
function UpdateStrategyInfo(i,len,rowRecs,userID,DoType){
	var objItmStrategyRow=null;
	if(DoType=="0"){     //单条数据
		objItmStrategyRow=rowRecs;
	}
	if((DoType=="1")||(DoType=="2")){    //本页审核通过 所以是多条
		objItmStrategyRow=rowRecs[i];
		if (DoType =="1" ) {  //本页审核通过
			objItmStrategyRow.AuditFlg="1"; 
		}
		if (DoType =="2" ) {  //本页审核取消
			objItmStrategyRow.AuditFlg="0"; 
		}
	}
	if(DoType=="3"){     //审核状态改变的才提交
		objItmStrategyRow=rowRecs[i];
		var tmpAuditFlg=objItmStrategyRow.AuditFlg;
		if(tmpAuditFlg=="1"){
			tmpAuditFlg="0";
		}else{
			tmpAuditFlg="1";
		}
		objItmStrategyRow.AuditFlg=tmpAuditFlg;
	}
	
	var ItmStrategyInfo=BuildItmStrategyInfo(objItmStrategyRow);              //构造项目知识库信息字符串
	var ItmStrategyDr=objItmStrategyRow.ItmStrategyDr;                            //知识库Dr
	//alert("ItmStrategyInfo="+ItmStrategyInfo+"||ItmStrategyDr="+ItmStrategyDr);
	//return 0;
	var Url=APP_PATH+"/dictool.ItmStrategyEditCtl/SaveItmStrategy" ;
	var data={
		ItmStrategyInfo:ItmStrategyInfo,
		ItmStrategyDr:ItmStrategyDr
	};
	//更新审核信息
	$.post(Url,data,function(data,textStatus){
			if(textStatus=="success"){
				if(data.status>=0){
					var index=i+1;
					//$('#progress').progressbar('setValue',rate); //设置进度条值
					if(index<len){     //判断是否更新完毕
						UpdateStrategyInfo(index,len,rowRecs,userID,DoType);
					}else{
						if((DoType=="1")||(DoType=="2")||(DoType=="3")){
							reloadStrategyGV('reload');
							alert("审核完成!");
						}else{ //单条审核过后 更新页面
							var tmpIndex=i;
							if(tmpIndex !=""){
								if(objItmStrategyRow.ItmStrategyDr==""){
									objItmStrategyRow.ItmStrategyDr=data.status;
								}
								
								$('#StrategyGV').datagrid('updateRow', {
									index:tmpIndex
									,row:objItmStrategyRow
								});
								//$('#StrategyGV').datagrid('refreshRow', tmpIndex);    //刷新行
								$('#StrategyGV').datagrid('beginEdit', tmpIndex);
							}
						}
					}
					
					/*
					if(index==len){  //审核后重新加载数据
						reloadStrategyGV('reload')
						$.messager.show({
							title:'温馨提示',
							msg:'审核完成！',
							timeout:2000,
							showType:'slide'
							,through:true
						});
					}*/
				}else{
					//$('#proWin').window('close');
					$.messager.alert('更新失败','审核信息更新失败，详细信息：'+data.info);
				}
			}else{
				//$('#proWin').window('close');
				$.messager.alert('系统错误','系统异常，请稍后重试');
			}
		},'json');
}

///******************************************************************
///功能说明：
///          知识库检索结果重新加载
///参数说明：
///          loadType->load 或者 reload
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

///加载因素配置数据集
function reloadConfigFacDetailGV(loadType){
	var ConDataDr=$("#CofingFactorDr").val();
	//alert("ConDataDr="+ConDataDr);
	if(ConDataDr==null){
		$.messager.alert("提示","请选择配置点因素！")
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
///功能说明：
///          知识库策略明细结果重新加载
///参数说明：
///          loadType->load 或者 reload
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
///功能说明：
///          知识库策略明细结果重新加载
///参数说明：
///          loadType->load 或者 reload
///******************************************************************
function reloadAddStrategyGV(loadType){
	
	var InputPam="";
	var strategykeySearch=$('#strategykeySearch').searchbox('getValue');                          //策略关键字
	InputPam=strategykeySearch+"^";
	//alert("InputPam="+InputPam);
	//加载就诊列表
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
///功能说明：
///          知识库对应的策略信息清空
///******************************************************************
function DictionaryStrategyInfoClear(){
	
	/*
	//知识库明细信息清空
	$('#DataSourceDesc').text("");
	$('#DataSource').val("");
	$('#rowid').val("");
	$('#reDoFlg').val("0");
	$('#dataTypeDesc').text("");         //审核标志
	$('#dataType').val("");
	
	$('#Code').text("");                 //编码
	$('#Desc').text("");                 //描述
	$('#MedicineUnique').text("");       //项目唯一码
	$('#ElectronicCode').text("");       //项目电子码
	$('#Explain').val("");               //医保说明
	$('#Remarks').val("");               //医保备注
	*/
	
	$('#rowid').val("");                 //选择的项目Dr
	$('#ItmCode').val("");            //选择的项目编码
	$('#ItmDesc').val("");             //选择的项目名称
	$('#HaveExpFlg').val("0");             //是否有公式
	
	//endEditRow();                        //编辑状态取消
	//reloadStrategyGV('load');            //策明细清空略
	$('#StrategyGV').datagrid('loadData',{total:0,rows:[]});
	
	FormulaClear();   //清空操作数区域
	
}

/// 设置备注信息维护窗口
function setEditCommonArea(){
	$('#Edit_Common_Area').window({
		title:'配置因素选择',
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
		,onBeforeOpen:function(){    //打开之前初始化窗口
			ClearCommonEditArea();                     //清空原有内容
			SetCommonEditAreaBySel();                //根据选择的备注设置编辑框的内容
		}
	});
	$('#Edit_Common_Area').window("close");
	
	$('#Edit_Factor_Area').window({
		title:'配置因素维护',
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
		,onBeforeOpen:function(){    //打开之前初始化窗口
			ClearFactorArea();                     //清空原有内容
			SetFactorArea();                //根据选择的备注设置编辑框的内容
		}
	});
	$('#Edit_Factor_Area').window("close");
	
	$("#Edit_ConfigMap_Area").window({
		title:'因素配置字典',
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
		,onBeforeOpen:function(){    //打开之前初始化窗口
			//clearEditConfig();
			reloadConfigFacDetailGV('load')                     //加载保存数据	
				
		}
	});
	$("#Edit_ConfigMap_Area").window("close");
	
	//影响因素的字典的可选值维护界面定义
	$("#FactorDic_Details_Area").window({
		title:'因素配置字典',
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
		,onBeforeOpen:function(){    //打开之前初始化窗口
			reloadFactorDicDetailGV('load');                     //加载保存数据	
		}
	});
	$("#FactorDic_Details_Area").window("close");
}


/// 根据选择的备注信息设置编辑区域的值
function SetCommonEditAreaBySel(){
	
	var SelCommonRow=$('#DictionaryGV').datagrid('getSelected');                                            //选中的行
	if (SelCommonRow!=null){
		var ConfigIndex=$('#DictionaryGV').datagrid('getRowIndex', SelCommonRow);       //选中的行索引
		//console.log(SelCommonRow)
		var ConfigDr=SelCommonRow.RowID;                        //备注Dr
		var ConfigCode=SelCommonRow.ConfigCode;              //配置点编码
		var ConfigDesc=SelCommonRow.ConfigDesc;               //配置点名称名称
		var ConfigCommon=SelCommonRow.ConfigCommon;            //备注信息
		var ConfigActiveFlg=SelCommonRow.ActiveFlg;             //是否启用 1 启用 0 未启用
		var HospitalNo=SelCommonRow.HospitalNo;                //院区编码
		
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

/// 初始化清空备注编辑区域的信息
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
///功能说明：
///          知识库对应的策略信息清空
///******************************************************************
function setAddDictionary(){
	$('#addDictionary').window({    
		title:'影响元素列表',
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
	//能检索功能
	//$('input[name=searchDickey]').on('keyup',reloadResult);  //根据输入搜索结果并显示
	
	//取消按钮按下
	$('#addCancelBtn').on('click',function(){
		$('#addDictionary').window("close");
	});
	
	//添加策略明细
	//$('#addConfirmBtn').on('click', SaveSelectedStrategys);          //保存选择的策略信息
	$('#addConfirmBtn').on('click', SaveConfigToFactors);				//保存项目对应的策略规则信息
}

//保存项目对应的策略规则信息
function SaveConfigToFactors(){
	//var SelectedRows=$('#AddStrategyGV').datagrid('getSelections');          //选择的策略行
	var SelectedRows=$('#AddStrategyGV').datagrid('getChecked');              //选择的策略行
	//console.log(SelectedRows)
	if(SelectedRows.length>0){     //选择了的策略保存
		SaveConfigToFactor(SelectedRows, 0, "1");           //保存项目的策略信息
	}else{
		alert("请至少选择一条策略规则!");
	}
}

function SaveConfigToFactor(SelectedRows, index, MutiFlg){
	var objItmConfigRow=null;
	if(MutiFlg=="1"){    //多条数据的场合
		var StrateLen=SelectedRows.length;              //策略数目
		if(index >= StrateLen){
			alert("入参不正确,请联系管理人员!");
			return 0;
		}else{
			objItmConfigRow=SelectedRows[index];
		}
	}else{
		objItmConfigRow=SelectedRows;               //单条数据的场合
	}
	var DictionaryRow=$('#DictionaryGV').datagrid('getSelected');
	var CollocationDr=DictionaryRow.RowID;			//配置点Dr
	var FactorDr=objItmConfigRow.RowID;			  	//配置因素Dr
	var CompareVal=objItmConfigRow.CompareVal;							    //因素比较值
	
	if(CompareVal==undefined){
		CompareVal="";
	}
	var CompareStartVal=objItmConfigRow.CompareStartVal;							//因素的范围开始值
	if(CompareStartVal==undefined){
		CompareStartVal="";
	}
	var CompareEndVal=objItmConfigRow.CompareEndVal;							//因素的范围结束值
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
		AuditFlg=objItmConfigRow.AuditFlg;     //审核标志
	}
	
	var XStr1="";
	var XStr2="";
	var XStr3="";
	var XStr4="";
	var XStr5="";
	var XStr6="";
	var ConfigToFactorInfo=CollocationDr+"^"+FactorDr+"^"+CompareVal+"^"+CompareStartVal;              //构造项目知识库信息字符串
	var ConfigToFactorInfo=ConfigToFactorInfo+"^"+CompareEndVal+"^"+AuditFlg+"^"+XStr1;
	var ConfigToFactorInfo=ConfigToFactorInfo+"^"+XStr2+"^"+XStr3+"^"+XStr4+"^"+XStr5+"^"+XStr6+"^"+DataFrom+"^"+CompareNM+"^"+FactorName;
	//var UserDr=LgUserID;                                 //操作员Dr
	var UserDr=session['LOGON.USERID'];
	
	if("ConDataDr" in objItmConfigRow){
		var ConfigToFactorDr=objItmConfigRow.ConDataDr;	   //配置因素ID
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
		if(MutiFlg=="1"){    //多条数据的场合
			if(index<(StrateLen-1)){
				index=index+1;
				SaveConfigToFactor(SelectedRows, index, MutiFlg);           //下一个选择的策略
			}else{
				
			}
		}
		$.messager.show({
			title:'提示',
			msg:'数据增加成功！',
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

/// 影响因素分类 可选值增加
function FDetaiAddBtnFun(){
	var FactorDicDr = $("#FactorDicDr").val();
	if(FactorDicDr==""){
		$.messager.alert("提示","未选中因素分类信息，请关闭窗口重新选中");
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
		$.messager.alert("提示","编码不能为空!");
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
			$.messager.alert("提示","保存失败："+data.info);
		}else{
			reloadFactorDicDetailGV("load");
			clearFactorDicDetailEdit();
			$.messager.show({
				title:'提示',
				msg:'保存成功！',
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
		$.messager.alert("提示","未选中因素信息，请关闭窗口重新选中");
		return;
	}
	
	var ProCode=""
	if($("#queryflg").val()=="1"){
		ProCode=$("#ProCodeCombo").combobox("getValue");             //如果下拉框显示出来，则取下拉框内容		
	}else{
		ProCode=$("#ProCode").val();   //下拉框隐藏状态，则取文本框内容		
	}
	if(ProCode==""){
		$.messager.alert("提示","配置编码不能为空！");
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
			$.messager.alert("提示","保存失败："+data.info);
		}else{
			reloadConfigFacDetailGV("load");
			clearEditConfig();
			$.messager.show({
				title:'提示',
				msg:'保存成功！',
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
		$.messager.alert("提示","请选择需要删除的数据");
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
				title:'提示',
				msg:'删除成功！',
				timeout:1000,
				showType:'slide',
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}
			});
		}else{
			$.messager.alert("提示","删除失败："+data.info);
		}
	})
}

//删除因素字典的可选值信息
function FDetaiDelBtnFun(){
	var FactorDetailDr=$("#FactorDetailDr").val();
	if(FactorDetailDr == null){
		$.messager.alert("提示","请选择需要删除的数据");
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
				title:'提示',
				msg:'删除成功！',
				timeout:1000,
				showType:'slide',
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}
			});
		}else{
			$.messager.alert("提示","删除失败："+data.info);
		}
	});
}

///删除配置电和因素的关联关系
function DeletConFactor(){
	var ConDataDr = $("#CofingFactorDr").val();
	var SelConFac = $("#StrategyGV").datagrid("getSelected");
	if(SelConFac==null){
		$.messager.alert("提示","未选中需要删除的因素");
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
				title:'提示',
				msg:'删除成功！',
				timeout:1000,
				showType:'slide',
				style:{
					right:'',
					top:document.body.scrollTop+document.documentElement.scrollTop,
					bottom:''
				}
			});
		}else{
			$.messager.alert("提示","删除失败："+data.info);
		}
	})
}

function SaveSelectedStrategys(){
	
	var SelectedRows=$('#AddStrategyGV').datagrid('getSelections');          //选择的策略行
	if(SelectedRows.length>0){     //选择了的策略保存
		SaveItmStrategy(SelectedRows, 0, "1");           //保存项目的策略信息
	}else{
		alert("请至少选择一条策略规则!");
	}
}

function SaveItmStrategy(SelectedRows, index, MutiFlg){
	var objItmStrategyRow=null;
	if(MutiFlg=="1"){    //多条数据的场合
		var StrateLen=SelectedRows.length;              //策略数目
		if(index >= StrateLen){
			alert("入参不正确,请联系管理人员!");
			return 0;
		}else{
			objItmStrategyRow=SelectedRows[index];
		}
	}else{
		objItmStrategyRow=SelectedRows;               //单条数据的场合
	}

	var ItmStrategyInfo=BuildItmStrategyInfo(objItmStrategyRow);              //构造项目知识库信息字符串
	//alert("ItmStrategyInfo="+ItmStrategyInfo);
	//return 0;
	var ItmStrategyDr="";
	if (("ItmStrategyDr" in objItmStrategyRow)) {
		ItmStrategyDr = objItmStrategyRow.ItmStrategyDr;                            //知识库Dr
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
				if(MutiFlg=="1"){    //多条数据的场合
					if(index<(StrateLen-1)){
						index=index+1;
						SaveItmStrategy(SelectedRows, index, MutiFlg);           //下一个选择的策略
					}else{
						reloadStrategyGV('reload');
						
						var AddOpenMode=$('#AddOpenMode').val();
						if(AddOpenMode=="1"){    //查询增加模式的时候，增加完成后，关闭窗口
							$('#addDictionary').window("close");
						}
					}
				}
			}else{
				$.messager.alert('系统错误','系统异常，请稍后重试');
			}
		},
		'json'
	);
}

/// 功能说明：构造项目知识库信息字符串
function BuildItmStrategyInfo(objItmStrategyRow)
{
	var HospitalNo=$('#hospitalNo').val();                    //1 医院编码
	var InsuType =$('#insuType').val();                         //2 医保类型
	var DataFrom=$("#DataFrom").val();                       //3 <!-- 数据来源(0 医保控费项目库 1 第三方导入到医保控费的his项目 2 直接从his的收费项目表中查询)  -->
	var ItmDr=$("#rowid").val();                                    //4 项目库Dr
	var ItmCode=$("#ItmCode").val();                           //5 项目编码
	var ItmDesc=$("#ItmDesc").val();                             //6 项目名称
	var StrategyDr=objItmStrategyRow.RowID                                             //7 中心词Dr
	var StrategyCode=objItmStrategyRow.KeywordCode;                             //8 中心词编码
	var StrategyDesc=objItmStrategyRow.Keyword;                                     //9 中心词描述
	var StrategyUseVal="";     //objItmStrategyRow.StrategyUseVal;                         //10 使用场景
	var AuditFlg="0";                                             //11 审核标志
	if(("AuditFlg" in objItmStrategyRow)){
		AuditFlg=objItmStrategyRow.AuditFlg;
	}
	var ControlLevel="";  //objItmStrategyRow.ControlLevel;                                 //12 控制等级
	var DetailLevel="";    //objItmStrategyRow.DetailLevel;                                      //13 策略等级
	var Formula="";       //objItmStrategyRow.Formula;                                              //14 策略关系
	var UserDr=LgUserID;                                                                             //15 操作员Dr
	var DataFrom=$('#DataFrom').val();                //数据来源 0 医保控费项目库 1 第三方导入到医保控费的his项目 2 直接从his的收费项目表中查询
	
	//1 医院编码^2 医保类型^3 数据来源^4 项目库Dr^5 项目编码^6 项目名称^7 策略规则Dr^8 策略规则编码^9 策略规则描述^10 使用场景^11 审核标志^12 控制等级^13 策略等级^14 策略等级^15 操作员Dr
	var ItmStrategyInfo=HospitalNo+"^"+InsuType+"^"+DataFrom+"^"+ItmDr+"^"+ItmCode;
	ItmStrategyInfo=ItmStrategyInfo+"^"+ItmDesc+"^"+StrategyDr+"^"+StrategyCode+"^"+StrategyDesc+"^"+StrategyUseVal;
	ItmStrategyInfo=ItmStrategyInfo+"^"+AuditFlg+"^"+ControlLevel+"^"+DetailLevel+"^"+Formula+"^"+UserDr+"^"+DataFrom;
	//var ItmStrategyDr=objItmStrategyRow.ItmStrategyDr;                            //知识库Dr
	
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
	
	//$("#StrategySubList a").live("click",function(){      ///live函数在jquery1.9及以上的版本中已被废弃了
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
		if(CheckConfigActiveFlg()!="1"){    //是否可以编辑验证
			return 0;
		}
		
		$.messager.confirm("删除", "确定删除当前公式?", function (r) {
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
		$.messager.alert("提示","编辑仅表达式可用！") ;
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
		$.messager.alert("提示","编辑仅表达式可用！") ;
		return false ;
	}
	
	var html=$(this).html() ;
	html="<a type='Operator'>"+html+"</a>" ;
	$("#Eidtformul").append(html) ;
}

function BuitlByData(Data){
	var optionName=Data.FactorName;   //表达式操作数名称
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
		AuditFlg=Data.AuditFlg;     //审核标记
		if(AuditFlg !="1") {
			continue;
		}
		BuitlByData(Data).appendTo("#StrategySubList") ;
	}
}

function SaveFormulFun(){
	if(CheckConfigActiveFlg()!="1"){    //是否可以编辑验证
		return 0;
	}
	
	if($("input[name=FormulaType]:checked").val() != "1")
	{
		$.messager.alert("提示","编辑仅表达式可用！") ;
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
			var optionName=Data.FactorName;   //表达式操作数名称
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
			$.messager.alert("提示","策略公式没有修改,不需要保存！") ;
			return false ;
		}
		$.messager.alert("提示","公式不可为空！") ;
		return false ;
	}
	
	//判断公式是否正确
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
	//var UseAdmType=$("#UseAdmType").combobox("getValue");                     //获取表达式的使用场景  C->通用 I->住院 O->住院意外
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
				title:'提示',
				msg:'数据保存成功！',
				timeout:2000,
				showType:'slide'
				,through:true
			});
			$("#Eidtformul").attr("tip",ExpressionDesc) ;
			$("#WarnInfo").html("&nbsp;") ;
		}else{
			$.messager.alert("提示","保存数据失败！ErrInfo："+data.info) ;
		}
	},"json") ;
}
// 删除已经存在的公式
function DeleteFormul()
{
	if($("#Eidtformul").attr("tip")==""){
		$.messager.show({
			title:'提示',
			msg:'无公式！',
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
				title:'提示',
				msg:'执行成功！',
				timeout:2000,
				showType:'slide'
				,through:true
			}) ;
			
			$("#HaveExpFlg").val("0");   //删除表达式后，表达式状态需要修改 +dongkf 2015 05 06
			$("#Eidtformul").attr("tip","");
			$("#WarnInfo").html("&nbsp;") ;
			$("#OldExpression").html(" ") ;
			//$("input[name=FormulaType][value=2]").click() ;
			//$HUI.radio("input[name=FormulaType][value=2]").setValue(true);
			$("#Eidtformul").html("") ;    //+dongkf 2020 01 11

			//ReSetEidtformul();    //重置公式信息
		}else{
			$.messager.alert("提示","执行失败！ErrInfo："+data.info) ;
		}
	},"json") ;
}
// 检测该字典如果已经存在公式，则恢复公式编辑
function ReSetEidtformul()
{	
	$cm({
		ClassName:"INSU.BL.ConfigPointCtl",
		MethodName:"GetExpressByCollectDrAjax",
		CollecationDr:$("#rowid").val()
	},function(data){
		if(data.ID!=""){
			$('#HaveExpFlg').val("1");   //有表达式 +dongkf 2015 05 06  
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
			$('#HaveExpFlg').val("0");   //无表达式 +dongkf 2015 05 06
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

var CopySourceDicDr="";    //+dongkf 2015 05 06 拷贝源的项目库Dr

function GrpInfoDetailGVOperate(item){
	var selected=$("#DictionaryGV").datagrid('getSelected');
	var HospitalNo=$('#hospitalNo').val();
	var InsuType=$('#insuType').val();
	var UpdateUser=session['LOGON.USERID'];
	var UseAdmType=$("#UseAdmType").combobox("getValue");
	
	if(item.text=="复制策略"){
		var url=APP_PATH+"/dic.INSUQCDictionarySategySubCtl/CopyDictionarySubByIDAjax";
		//数据来源
		$.post(url,{
			hospitalNo:HospitalNo,
			insuType:InsuType,
			DictDr:selected.DictionaryDr,
			reDoFlg:0			
		},function(data){
			if(data.flag<0){
				CopySourceDicDr="";
				$.messager.alert("提示",data.info);
			} 
			else{
				CopySourceDicDr=selected.DictionaryDr;   //+dongkf 2015 05 06 拷贝源项目库Dr
				$.messager.show({
					title:'温馨提示',
					msg:data.info,
					timeout:2000,
					showType:'slide'
					,through:true
				})
			}	
		},"json")
	}
	if(item.text=="粘贴策略"){
		if(CopySourceDicDr==""){
			alert("没有执行[复制策略]操作，或者执行复制操作的项目没有对应的策略明细信息");
			return ;
		}else{
			var selected=$("#DictionaryGV").datagrid('getSelected');
			var HospitalNo=$('#hospitalNo').val();
			var InsuType=$('#insuType').val();
			var UpdateUser=session['LOGON.USERID'];
			var UseAdmType=$("#UseAdmType").combobox("getValue");
	
			var url=APP_PATH+"/dic.INSUQCDictionarySategySubCtl/PasteDictionarySubByIDAjax";
			var ExtStr=CopySourceDicDr+"^";      //+dongkf 2015 05 06 扩展字符串 拷贝源项目库Dr^
			var ExtStr=ExtStr+UseAdmType+"^"     //表达式使用场景Dr^UseAdmType^
			$.post(url,{
				hospitalNo:HospitalNo,
				insuType:InsuType,
				DictDr:selected.DictionaryDr,
				User:UpdateUser
				,ExtStr:ExtStr
				},function(data){
					if(data.flag=="-1"){
						$.messager.show({
							title:'温馨提示',
							msg:'粘贴策略出错'+data.info,
							timeout:2000,
							showType:'slide'
							,through:true
						});
					}else  if(data.flag=="-2"){
						$.messager.show({
							title:'温馨提示',
							msg:'已存在',
							timeout:2000,
							showType:'slide'
							,through:true
						});
					}else{
						$.messager.show({
							title:'温馨提示',
							msg:'策略明细拷贝成功',
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


//根据对象数组中对象的编码获取对应的描述
function getArrDescByCode(code, objArr){
	
	var rtn=code;
	var obj=null;
	var obj,tmpCode,tmpDesc;
	var len=objArr.length;
	for(i=0;i<len;i++){
		obj=objArr[i];
		
		///2015 03 10 lilei 修改 
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

/// 判断当前配置点的影响因素是否可以编辑 已经启用的配置点不能编辑
function CheckConfigActiveFlg(){
	var RtnFlg="0";
	
	var SelCommonRow=$('#DictionaryGV').datagrid('getSelected');                                            //选中的行
	if (SelCommonRow!=null){
		var ConfigIndex=$('#DictionaryGV').datagrid('getRowIndex', SelCommonRow);       //选中的行索引
		var ConfigDesc=SelCommonRow.ConfigDesc;               //配置点名称名称
		var ActiveFlg=SelCommonRow.ActiveFlg;                      //启用标记 1 启用 0 未启用
		if(ActiveFlg=="1"){
			var ErrMsgInfo="行:"+(ConfigIndex+1)+" ["+ConfigDesc+"] 的配置点已经启用，请停用后再编辑!"
			alert(ErrMsgInfo);
		}else{
			RtnFlg="1";
		}
	}else{
		alert("请选择一行配置点数据!");
	}
	
	return RtnFlg;
}

///加载因素配置数据集
function reloadFactorDicDetailGV(loadType){
	var FactorDicDr=$("#FactorDicDr").val();
	//alert("FactorDicDr="+FactorDicDr);
	if(FactorDicDr==null){
		$.messager.alert("提示","请选择因素分类字典信息！")
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
