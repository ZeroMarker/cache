﻿/**
 * 费别到医保目录对照
 * FileName:insuadmreasonToTaridictionarycon.js
 * xubaobao 2019-04-04
 * 版本：V1.0
 * hisui版本:0.1.0
 */

//===========修改部分=================开始
//在医保字典表中的基本编码(不包含医保类型编码,医保类型编码由程序来匹配。即：数据库中实际配置的是DosageZZA)
var DicCode="Tari";             //医保接口类型 
// 获取字典数据的类名及方法名称(His中的字典列表)
// 这里的方法由自己来写返回值 固定格式(List)
var HisDicClass="web.INSUDictionaryContrast";         //类名
var HisDicMethod="GetHisAdmreasonList";                            //方法名
//===========修改部分=================结束
$(function(){
	setPageLayout() ;
	setElementEvent();
	
	RefushGridViews();       //加载字典数据
});

function setElementEvent()
{
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
		url:APP_PATH+"/INSUDictionaryContrast/GetHospitalList",
		valueField:'code',
		textField:'desc'
		,onLoadSuccess:function(){
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
		url:APP_PATH+"/INSUDictionaryContrast/GetHisDicAndConAjax",
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
		}
		
	})

	//医保字典信息
	$('#MedicalGV').datagrid({
		url:APP_PATH+"/INSUDictionaryContrast/GetINSUDLLTypeDicAjax",
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
			
		}
		,onDblClickRow:function(rowIndex, rowData){    //双击保存对照关系
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
		//alert("请选择一条his的字典信息，然后在做对照");
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
	var InsuType="";    //医保类型
	var HospitalNo="";
	if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //医院编码
	}
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
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
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
	//var Type=DicCode;                     //字典类型识别码
	var Type="DLLType";
	var SearchKey=$('#SearchMedBox').searchbox('getValue');   //检索关键字
	var ExtStr=SearchKey;
	//alert("DLLType="+DLLType+"|ExtStr"+ExtStr);
	
	//重新加载查询结果
	$('#MedicalGV').datagrid(loadType, {
		Type:Type
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

	var InsuType=""     //医保类型
	var HospitalNo="";
	if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //医院编码
	}
	var SearchKey=$('#SearchHisBox').searchbox('getValue');   //检索关键字
	
	var InsuConType=$('#InsuConTypeBox').combobox('getValue');     //医保对照类型     add by xubaobao 2019 03 28
	var ExtStr=classname+"^"+methodname+"^"+SearchKey+"^"+InsuConType;
	//alert("ExtStr="+ExtStr+"KeyCode="+KeyCode+"|InsuType="+"|HospitalNo="+HospitalNo);
	
	//重新加载查询结果
	$('#HISInfoGV').datagrid(loadType, {
		KeyCode:KeyCode
		,InsuType:InsuType
		,HospitalNo:HospitalNo
		,ExtStr:ExtStr
	});
	return 1;
}

//费别对照数据批量导入
function Import()
{
	var KeyCode=DicCode;
	var InsuType=""     //医保类型
	var HospitalNo="";
	if($("#hospitalDiv").is(":hidden")==false){
		HospitalNo=$('#HospitalBox').combobox('getValue');   //医院编码
	}
	importData(KeyCode,InsuType,HospitalNo);		 //insuimportdictionarycon.js
	reloadHisDicConGV('reload');
}


/*
///******************************************************************
///功能说明：
///          医师数据导入
///******************************************************************
function importData()
{
	try{
		var fd = new ActiveXObject("MSComDlg.CommonDialog");
		fd.Filter = "*.xls"; //过滤文件类别
		fd.FilterIndex = 2;
		fd.MaxFileSize = 128;
		fd.ShowOpen();
		filePath=fd.filename;//fd.filename是用户的选择路径
		$.messager.progress({
			title: "提示",
			msg: '正在导入字典数据',
			text: '导入中....'
		});
		if(filePath=="")
		{
			$.messager.alert('提示','请选择文件！')
			return ;
		}
		var ErrMsg="";     //错误数据
		var errRowNums=0;  //错误行数
		var sucRowNums=0;  //导入成功的行数
    
		xlApp = new ActiveXObject("Excel.Application"); 
		xlBook = xlApp.Workbooks.open(filePath); 
		xlBook.worksheets(1).select(); 
		var xlsheet = xlBook.ActiveSheet;
		var rows=xlsheet.usedrange.rows.count;
		var columns=xlsheet.usedRange.columns.count;
		try{
			for(i=2;i<=rows;i++){
				var pym="";
				var Instring=buildImportStr(xlsheet,i);
				
				var KeyCode=DicCode;
				var InsuType=""
				var HospitalNo=""
				var userDr=LgUserID;                        //用户Dr
				var ConInfo=Instring+"^"+userDr+"^"+HospitalNo    //增加医院编号
				
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
								sucRowNums=sucRowNums+1;
								//reloadHisDicConGV('reload');
							}else{
								errRowNums=errRowNums+1; 
								if(ErrMsg==""){
									ErrMsg=i;
								}else{
									ErrMsg=ErrMsg+"\t"+i;
								}
								//$.messager.alert('温馨提醒','对照信息保存失败：'+info);
							}
					}else{
						$.messager.alert('系统错误','系统异常，请稍后重试');
					}
				},
				'json');
			}
		
			if(ErrMsg==""){
				$.messager.alert('提示','数据正确导入完成');
				
			}else{
				var tmpErrMsg="成功导入【"+sucRowNums+"/"+(rows-1)+"】条数据";
				tmpErrMsg=tmpErrMsg+"失败数据行号如下：\n\n"+ErrMsg;
				$.messager.alert('提示',tmpErrMsg);   
			}
			
			reloadHisDicConGV('reload');
		}	
		catch(e){
			$.messager.alert('提示',"导入时发生异常0：ErrInfo："+e.message);  
		}
		finally{
			xlBook.Close (savechanges=false);
			xlApp.Quit();
			xlApp=null;
			xlsheet=null;
		}
	}	
	catch(e){
		$.messager.alert('提示',"导入时发生异常1："+e.message);
	}
	finally{
		setTimeout('$.messager.progress("close");', 4 * 1000);
	} 
}

function buildImportStr(xlsheet,rowindex){
	var tmpVal="";
	//HIS编码^HIS描述^医保编码^医保名称
	Instring=SetValue(xlsheet.Cells(rowindex,1).value);                     //分类
	Instring=Instring+"^"+SetValue(xlsheet.Cells(rowindex,2).value);       
	Instring=Instring+"^"+SetValue(xlsheet.Cells(rowindex,3).value);       
	Instring=Instring+"^"+SetValue(xlsheet.Cells(rowindex,4).value); 
	return Instring;
}

function SetValue(value)
{
	if(value == undefined){
		value="" ;
	}
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}
*/
function selectHospCombHandle(){
	RefushGridViews();
	doSearchDicConInfo();	
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

