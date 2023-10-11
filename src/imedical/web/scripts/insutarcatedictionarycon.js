/**
 * 费用类型对照JS
 * FileName:insutarcatedictionarycon.js
 * xubaobao 2019-04-04
 * 版本：V1.0
 * hisui版本:0.1.0
 */

//===========修改部分=================开始
//在医保字典表中的基本编码(不包含医保类型编码,医保类型编码由程序来匹配。即：数据库中实际配置的是DosageZZA)
var DicCode="med_chrgitm_type";             //费用类型 
// 获取字典数据的类名及方法名称(His中的字典列表)
// 这里的方法由自己来写返回值 固定格式(List)
var HisDicClass="web.INSUDictionaryContrast";         //类名
var HisDicMethod="GetHisTarCateList";                            //方法名
//===========修改部分=================结束
$(function(){
	setPageLayout() ;
	setElementEvent();
});

function setElementEvent()
{
	//gridview 宽度自适应
	/*
	$(window).resize(function(){
		DataGVWidthResize('HISInfoArea');    //宽度自适应
		DataGVWidthResize('MedicalArea');    //宽度自适应
	});*/
	//$('#TitleName').html(PageName);
	
	//his字典及对照关系查找
	/*
	$('#SearchHisBtn').on('click',function(){
		reloadHisDicConGV('load');
	});*/
	//回车事件查找his字典及对照关系
	/*
	$('#SearchHisBox').on('keyup',function(event){
		var keycode = (event.keyCode ? event.keyCode : event.which);
		if(keycode!=13){
			return false;
		}
		reloadHisDicConGV('load');
	});*/
	
	//医保字典列表数据查找
	/*
	$('#SearchMedBtn').on('click',function(){
		reloadInsuDicGV('load');
	});*/
	//回车事件查找医保字典列表数
	/*
	$('#SearchMedBox').on('keyup',function(event){
		var keycode = (event.keyCode ? event.keyCode : event.which);
		if(keycode!=13){
			return false;
		}
		reloadInsuDicGV('load');
	});*/
}

//查询对照
function doSearchDicConInfo(){
	reloadHisDicConGV('load');
}

//查询字典
function doSearchDicInfo(){
	reloadInsuDicGV('load');
}

function setPageLayout(){
	//院区下拉框
	$('#HospitalBox').combobox({
		valueField:'code',
		textField:'desc'
		,onLoadSuccess:function(){
		}
		,onSelect:function(record){
			//alert(22);
		}
	})

	//医保类型下拉框
	$('#InsuTypeBox').combobox({
		//url:APP_PATH+"/INSUDictionaryContrast/GetDicDataList&DicKey=DLLType&ExtStr=",
		valueField:'diccode',
		textField:'dicdesc'
		,onLoadSuccess:function(){
			var $comboxObj=$('#InsuTypeBox');
			var data=$comboxObj.combobox('getData');
			if(data.length>0){
				var defaultVal=data[0].diccode;
				$comboxObj.combobox('setValue',defaultVal);
				//RefushGridViews();
			}
		}
		,onSelect:function(record){
			RefushGridViews();
		}
	})
	
	//对照类型
	$('#InsuConTypeBox').combobox({   
	 	panelHeight:100, 
	    valueField:'Code',   
	    textField:'Desc',
	    data: [{
			Code: '1',
			Desc: '未对照'
		},{
			Code: '2',
			Desc: '已对照'
		},{
			Code: '3',
			Desc: '全部'
		}]
		,onSelect:function(record){
			RefushGridViews();
		}

	}); 
	$('#InsuConTypeBox').combobox('setValue',3);

	$('#HISInfoGV').datagrid({
		fit:true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20,30,50],
		frozenColumns: [[
		{field:"Check",checkbox:true},
		{field:'delCon',title:'撤销对照',width:70
			,formatter:function(value,row,index){
				if(row.MedCode!=""){
					//return "<a style='width:60px;' class='dicconbtn hisui-linkbutton' data-options='plain:true' href='#' />";
					return "<a href='#' onclick='DelCon("+index+','+JSON.stringify(row)+")'>\
						<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/undo.png ' border=0/>\
						</a>";
				}else{
					return "";
				}
			}
		}]],
		columns: [[
		{field:'HisCode',title:'HIS编码',width:100},
		{field:'HisDesc',title:'HIS描述',width:130},
		{field:'MedCode',title:'医保编码',width:100},
		{field:'MedDesc',title:'医保描述',width:130}
		,{field:'UserNM',title:'对照人',width:120}
		,{field:'UpdateDt',title:'对照日期',width:100}
		,{field:'UpdateTime',title:'对照时间',width:100}
		,{field:'RowId',title:'对照Dr',width:100,hidden:true}
		]]
		,onLoadSuccess:function(){
		}
		,onDblClickRow:function(rowIndex, rowData){    //双击保存对照关系
			var RowId=rowData.RowId;    //对照Dr
			if((RowId!="")&&(rowData.MedCode!="")){
				$.messager.confirm('温馨提醒', '您确定要删除当前的对照关系？', function(r){
					if (r){
						DeleteHisDicConDo(rowData);    //删除对照关系的ajax操作
					}
				});
			}
		}
		,onCheck:function(rowIndex,rowData){
			//alert("onCheck");
		}
		
	})

	//医保字典信息
	$('#MedicalGV').datagrid({
		url:APP_PATH+"/INSUDictionaryContrast/GetINSUDicAjax",
		fit: true,
		border: false,
		pagination: true,
		rownumbers: true,
		pageSize:20,
		pageList:[20,50,100],
		columns:[[
		    {field:'dodo',title:'对照',width:80
				,formatter:function(value,row,index){
					//return "<a style='width:50px;' title='请点击对照' class='dicinfobtn hisui-linkbutton' data-options='plain:true' href='#' />";
					return "<a href='#' onclick='SaveCon("+index+','+JSON.stringify(row)+")'>\
					<img style='padding-left:7px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png ' border=0/>\
					</a>";
				}
			}
			,{field:'diccode',title:'医保编码',width:120}
			,{field:'dicdesc',title:'医保名称',width:160}
		]]
		,onLoadSuccess:function(){
			/*$('.dicinfobtn').linkbutton({
				iconCls: 'icon-compare'
			});*/
		}
		,onDblClickRow:function(rowIndex, rowData){    //双击保存对照关系
			//SaveHisDicCon(rowData);           //一对一保存方式
			SaveHisDicConMuti(rowData);      //一对多保存方式
		}
	})
	
}

function SaveHisDicConMuti(InsuRowData){
	var lens=0;
	var CheckedRecs=$('#HISInfoGV').datagrid('getChecked');      //GridView 选择的数据行
	if((CheckedRecs!=null)&&(CheckedRecs!='undefined')){
		lens=CheckedRecs.length;
		if(lens==0){
			//alert('请选择数据!');
			$.messager.alert("简单提示", "请选择数据对照!", "info");
			return "";
		}
	}else{
		$.messager.alert("简单提示", "请选择数据对照!", "info");
		return "";
	}
	
	var HisSelRowData=null;
	var tmpstr="";
	var WarnMessge="";
	var RowId="";
	var MedCode="";
	var hisDicDesc="";
	var ReSaveDataFlg="0";
	for(var i=0; i<lens; i++){
		HisSelRowData=CheckedRecs[i];
		
		RowId=HisSelRowData.RowId;        //对照信息的表Dr
		MedCode=HisSelRowData.MedCode;    //医保字典编码
		hisDicDesc=HisSelRowData.HisDesc;     //his字典的描述
		/*if((RowId !="")&&(MedCode !="")){     //已经对照过的字典
			if(confirm('该项目已经对照过，是否要把 '+HisSelRowData.HisDesc+' 重新对照成 '+InsuRowData.dicdesc+' 吗?')){
				SaveHisDicConDo(HisSelRowData, InsuRowData);    //保存对照关系的ajax操作
			}else{
			}
			$.messager.confirm('温馨提醒', '当前字典已经存在对照信息，您确定要重新对照吗？', function(r){
				if (r){
					SaveHisDicConDo(CheckedRecs[HisSelRowData, InsuRowData);    //保存对照关系的ajax操作
				}
			});
		}else{
			SaveHisDicConDo(HisSelRowData, InsuRowData);    //保存对照关系的ajax操作
		}
		*/
		SaveHisDicConDoALL(HisSelRowData, InsuRowData);    //保存对照关系的ajax操作
	}
}

///查询对照和字典的最新值
function RefushGridViews(){
	reloadHisDicConGV('load');
	reloadInsuDicGV('load');
}

//保存his字典与医保字典的对照关系
function SaveHisDicCon(InsuRowData){
	
	var HisSelRowData=$('#HISInfoGV').datagrid('getSelected');
	if(HisSelRowData==null){
		$.messager.alert("简单提示", "请选择数据对照!", "info");
		return 0;
	}
	var RowId=HisSelRowData.RowId;        //对照信息的表Dr
	var MedCode=HisSelRowData.MedCode;    //医保字典编码
	if((RowId !="")&&(MedCode !="")){
		$.messager.confirm('温馨提醒', '当前字典已经存在对照信息，您确定要重新对照吗？', function(r){
			if (r){
				SaveHisDicConDo(HisSelRowData, InsuRowData);    //保存对照关系的ajax操作
			}else{
				return 0;
			}
		});
	}else{
		SaveHisDicConDo(HisSelRowData, InsuRowData);    //保存对照关系的ajax操作
	}
}

function SaveHisDicConDoALL(HisSelRowData, InsuRowData){
	if(HisSelRowData.RowId !=""){ 
		$.messager.confirm('温馨提醒', '当前字典已经存在对照信息，是否要把  '+HisSelRowData.HisDesc+'  重新对照成  '+InsuRowData.dicdesc+'?', function(r){
			if (r){
				SaveHisDicConDo(HisSelRowData, InsuRowData);
			}else{
				return;
			}
		});
	}else{
		SaveHisDicConDo(HisSelRowData, InsuRowData);    //保存对照关系的ajax操作
	}
}


////功能说明：保存对照关系的ajax操作
function SaveHisDicConDo(HisSelRowData, InsuRowData){
	var KeyCode=DicCode;                                                     //字典类型识别码
	var InsuType=$('#InsuTypeBox').combobox('getValue');     //医保类型
	var HospitalNo=PUBLIC_CONSTANT.SESSION.HOSPID; 
	/*if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //医院编码
	}*/
	var HisCode=HisSelRowData.HisCode;          //HIS编码
	var HisDesc=HisSelRowData.HisDesc;          //HIS描述
	var diccode=InsuRowData.diccode             //医保编码
	var dicdesc=InsuRowData.dicdesc             //医保名称
	var userDr=LgUserID;                        //用户Dr
	var ConInfo=HisCode+"^"+HisDesc+"^"+diccode+"^"+dicdesc+"^"+userDr+"^"+HospitalNo    //增加医院编号
	//alert("ConInfo="+ConInfo+"|KeyCode="+KeyCode+"|InsuType="+InsuType);
	
	$.post(
		APP_PATH+"/INSUDictionaryContrast/SaveDicConAjax",
		{
			KeyCode:KeyCode
			,InsuType:InsuType
			,HospitalNo:HospitalNo
			,ConInfo:ConInfo
		},
		function(data,textStatus){
			if(textStatus=="success"){
				if(data.status>0){
					reloadHisDicConGV('reload');
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					//$.messager.show({title:'提示',msg:'数据保存成功！',timeout:2000,showType:'slide'});
				}else{
					$.messager.alert('温馨提醒','对照信息保存失败：'+info);
				}
			}else{
				$.messager.alert('系统错误','系统异常，请稍后重试');
			}
		},
		'json'
	);
}

////功能说明：删除his字典与医保字典的对照关系
function DeleteHisDicConDo(rowData){
	var RowId=rowData.RowId;    //对照Dr
	var ExtStr="";
	
	$.post(
		APP_PATH+"/INSUDictionaryContrast/DelDicConAjax",
		{
			RowId:RowId
			,ExtStr:ExtStr
		},
		function(data,textStatus){
			if(textStatus=="success"){
				if(data.status>0){
					reloadHisDicConGV('reload');
					$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
					//$.messager.show({title:'提示',msg:'数据删除成功！',timeout:2000,showType:'slide'});
				}else{
					$.messager.alert('温馨提醒','对照信息删除失败：'+info);
				}
			}else{
				$.messager.alert('系统错误','系统异常，请稍后重试');
			}
		},
		'json'
	);
}

////设置医保字典集合列表数据
function reloadInsuDicGV(loadType){

	var KeyCode=DicCode;                                                     //字典类型识别码
	var InsuType=$('#InsuTypeBox').combobox('getValue');     //医保类型
	//var SearchKey=$('#SearchMedBox').val();                          //检索关键字
	var SearchKey=$('#SearchMedBox').searchbox('getValue');   //检索关键字
	var ExtStr=SearchKey+"^"+PUBLIC_CONSTANT.SESSION.HOSPID;
	//alert("KeyCode="+KeyCode+"|ExtStr"+ExtStr);
	
	//重新加载查询结果
	$('#MedicalGV').datagrid(loadType, {
		KeyCode:KeyCode
		,InsuType:InsuType
		,ExtStr:ExtStr
	});
	return 1;
}

////设置his字典数据、医保数据以及对照数据列表
function reloadHisDicConGV(loadType){
	
	var KeyCode=DicCode;                     //字典类型识别码
	var classname=HisDicClass;              //his字典获取方法所在的类名
	var methodname=HisDicMethod;     //his字典获取方法名称
	if((classname=="")||(classname=="")||(methodname=="")){
		//alert("请联系管理员，配置了字典获取方法以后再查询");
		$.messager.alert("简单提示", "请联系管理员，先配置字典获取方法以后再查询!", "info");
		return 0;
	}

	var InsuType=$('#InsuTypeBox').combobox('getValue');     //医保类型
	var HospitalNo=PUBLIC_CONSTANT.SESSION.HOSPID; 
	/*if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //医院编码
	}*/
	//var SearchKey=$('#SearchHisBox').val();                    //检索关键字
	var SearchKey=$('#SearchHisBox').searchbox('getValue');   //检索关键字
	
	var InsuConType=$('#InsuConTypeBox').combobox('getValue');     //医保对照类型     add by xubaobao 2019 03 28
	//var ExtStr=classname+"^"+methodname+"^"+SearchKey;
	var ExtStr=classname+"^"+methodname+"^"+SearchKey+"^"+InsuConType;
	//alert("ExtStr="+ExtStr+"KeyCode="+KeyCode+"|InsuType="+"|HospitalNo="+HospitalNo);
	
	$('#HISInfoGV').datagrid('options').url = APP_PATH+"/INSUDictionaryContrast/GetHisDicAndConAjax";
	
	//重新加载查询结果
	$('#HISInfoGV').datagrid(loadType, {
		KeyCode:KeyCode
		,InsuType:InsuType
		,HospitalNo:HospitalNo
		,ExtStr:ExtStr
	});
	
	return 1;
}


//费用分类对照数据批量导入
function Import()
{
	var KeyCode=DicCode;
	var InsuType=$('#InsuTypeBox').combobox('getValue');     //医保类型
	var HospitalNo=PUBLIC_CONSTANT.SESSION.HOSPID; 
	/*if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //医院编码
	}*/
	importData(KeyCode,InsuType,HospitalNo);		 //insuimportdictionarycon.js
	reloadHisDicConGV('reload');
}
function selectHospCombHandle(){
	$('#InsuTypeBox').combobox('clear');
	var ExtStr = PUBLIC_CONSTANT.SESSION.HOSPID;  //增加院区 20230314 JinS1010
	$('#InsuTypeBox').combobox('options').url = APP_PATH+"/INSUDictionaryContrast/GetDicDataList&DicKey=DLLType&ExtStr="+ExtStr;
	$('#InsuTypeBox').combobox('reload');
	//RefushGridViews();
	setTimeout(function(){
		doSearchDicInfo();
		doSearchDicConInfo();
	},300)
		
}
function SaveCon(index,rowDataInfo){
	//SaveHisDicCon(rowDataInfo);
	SaveHisDicConMuti(rowDataInfo);      //一对多保存方式*/	
}
function DelCon(index,rowDataInfo){
	$.messager.confirm('温馨提醒', '您确定要删除当前的对照关系？', function(r){
		if (r){
			DeleteHisDicConDo(rowDataInfo);    //删除对照关系的ajax操作
		}
	});
}