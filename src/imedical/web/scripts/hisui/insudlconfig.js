/**
 * FileName: insudlconfig.js
 * Anchor: Xubinbin
 * Date: 2020-03-04
 * Description:
 */
 var edit=0;
 var editIndex=-1;
 function BodyLoadHandler(){
	//初始化页面的控件
	init();
 }
/**
 * @method init
 * @param 
 * @author xubinbin
 * Description: 页面加载的初始化和事件的声明
 */
function init(){
	//初始化医保类型下拉列表
	initInsuType();
	//初始化业务表名称下拉列表
	initTableClsName();
	//DHCWeb_ComponentLayout();
	initTableList();
	//导入按钮事件
	/*
	$HUI.linkbutton('#import', {
		onClick: function () {
			Import_OnClick();
		}
	});
	*/
	$HUI.linkbutton('#find', {
		onClick: function () {
			loadDataList();
		}
	});
	$(document).keydown(function(e){
		 Doc_OnKeyDown(e);
	 });
}
/**
 * @method initInsuType
 * @param 
 * @author xubinbin
 * Description: 加载医保类型
 */
function initInsuType(){
	var id='insuType';	//下拉框id
	var DicType="DLLType";  //医保类型字典类型编码为:DLLType
	initCombobox(id,DicType);
}

/**
 * @method initTableClsName
 * @param 
 * @author xubinbin
 * Description: 加载业务类名称
 */
function initTableClsName(){
	var id='TableClsName';	//下拉框id
	var DicType="DownLoadBusinessList";  //医保类型字典类型编码为:DLLType
	initCombobox(id,DicType);
}
/**
 * @method Import_OnClick
 * @param 
 * @author xubinbin
 * Description: 导出的点击事件
 */
function Import_OnClick(){
	//alert(0)
	//alert($("#TableDataList").datagrid('getRows').length)
}




/**
 * @method initTableList
 * @param 
 * @author xubinbin
 * Description: 初始化数据列表
 */
function initTableList() {
	
	$HUI.datagrid('#TableDataList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		autoRowHeight: false,
		rownumbers: true,
		fixRowHeight:90,
		url: $URL,
		pagination:true,
		pageSize:100,
		pageList:[100],
		columns: [[{
					title: '列属性编码',
					field: 'ColProCode',
					align: 'left',
					width: 150
				}, {
					title: '列属性名',
					field: 'ColProName',
					align: 'left',
					width: 150
				}, {
					title: '不能更新',
					field: 'NotUpateFlg',
					align: 'center',
					width: 70,
					sortable:true,
					formatter: function (value, row, index) {
						return (value == "1") ? '<input  id="NotUpateFlg'+index+'" type="checkbox" onclick=\'changeChecked("NotUpateFlg",'+index+')\' data-options='+"checked:true"+' checked/>' : '<input class='+'hisui-checkbox'+' id="NotUpateFlg'+index+'" onclick=\'changeChecked("NotUpateFlg",'+index+')\'+ type="checkbox"/>';
					},
					sorter:function (a,b) { //让勾选了的列排到前面
                   		return (a<b?1:-1);
                	}
				}, {
					title: '差异比较关键字',
					field: 'CompareFlg',
					align: 'center',
					width: 120,
					sortable:true,
					formatter: function (value, row, index) {
						return (value == "1") ? '<input  type="checkbox" id="CompareFlg'+index+'" onclick=\'changeChecked("CompareFlg",'+index+')\' data-options='+"checked:true"+' checked/>' : '<input class='+'hisui-checkbox'+' id="CompareFlg'+index+'" onclick=\'changeChecked("CompareFlg",'+index+')\'  type="checkbox"/>';
					},
					sorter:function (a,b) { //让勾选了的列排到前面
                   		return (a<b?1:-1);
                	}
				}, {
					title: '非空验证',
					field: 'NullCheckFlg',
					width: 70,
					align: 'center',
					sortable:true,
					formatter: function (value, row, index) {
						return (value == "1") ? '<input  type="checkbox" id="NullCheckFlg'+index+'" onclick=\'changeChecked("NullCheckFlg",'+index+')\' data-options='+"checked:true"+' checked/>' : '<input class='+'hisui-checkbox'+' id="NullCheckFlg'+index+'" onclick=\'changeChecked("NullCheckFlg",'+index+')\' type="checkbox"/>';
					},
					sorter:function (a,b) { //让勾选了的列排到前面
                   		return (a<b?1:-1);
                	}
				}, {
					title: '显示顺序',
					field: 'ShowIndexValue',
					width: 70,
					align: 'center',
					formatter: function (value, row, index) {
						var html='<img src="../images/u226.png"   style="width:19px;transform:rotate(90deg);height:11px" onclick="changeShowIndex('+index+',\'up\')"/>'
						html+='<img src="../images/u226.png"  style="width:19px;transform:rotate(270deg);height:11px" onclick="changeShowIndex('+index+',\'down\')"/>'
						return html;
					}
				}, {
					title: '数据类型',
					field: 'DataType',
					width: 90,
					formatter: function(value) {
						var returnValue=""
						switch(value) {
     						case "String":
        						returnValue="文本类型";
        						break;
     						case "Date":
        						returnValue="日期类型";
        						break;
							case "Integer":
        						returnValue="数字类型";
        						break;
        					case "Time":
        						returnValue="时间类型";
        						break;
     						default:
        						returnValue=value;
						} 
						return returnValue;
					},
					editor: {
						type: 'combobox',//下拉框
						options: {
							valueField: 'DataType',//对应为表格中的field
							textField: 'Text',//显示值
							editable: false,
							data: [
							{	DataType:"文本类型",
								Text:"文本类型"},
							{   DataType:"数字类型",
								Text:"数字类型"},
							{   DataType:"日期类型",
								Text:"日期类型"},
							{   DataType:"时间类型",
								Text:"时间类型"}
							]
						}
					}
					
				}, {
					title: '可选值',
					field: 'OptionVales',
					width: 150,
					align: 'left',
					editor: {
						type: 'text',//文本框
						options: {
							required: false
						}
					}
					
				},{
					title: '备用1',
					field: 'ExtStr1',
					align: 'left',
					width: 100,
					editor: {
						type: 'text',//文本框
						options: {
							required: false
						}
					}
					
				},{
					title: '备用2',
					field: 'ExtStr2',
					align: 'left',
					width: 100,
					editor: {
						type: 'text',//文本框
						options: {
							required: false
						}
					}
					
				}, {
					title: '备用3',
					field: 'ExtStr3',
					align: 'left',
					width: 100,
					editor: {
						type: 'text',//文本框
						options: {
							required: false
						}
					}
					
				}, {
					title: '备用4',
					field: 'ExtStr4',
					align: 'left',
					width: 70,
					editor: {
						type: 'text',//文本框
						options: {
							required: false
						}
					}
					
				},{
					title: '备用5',
					field: 'ExtStr5',
					align: 'left',
					width: 70,
					editor: {
						type: 'text',//文本框
						options: {
							required: false
						}
					}
					
				}, {
					title: 'id',
					field: 'id',
					hidden: true,
					width: 100
					
				},{
					title: 'ShowIndex',
					field: 'ShowIndex',
					hidden: true,
					width: 100
					
				}
			]],
        onClickCell:function (rowIndex, field, value){  //单击单元格时触发的事件
        	if(editIndex>-1)
        		getEditorValue(editIndex);
	        if(field=="OptionVales"||(field>="ExtStr1"&&field<="ExtStr5")||field=="OptionVales"||field=="DataType"){ //点击内置的编辑器的单元格，让该行可以编辑
	        	$("#TableDataList").datagrid('beginEdit', rowIndex);
	        	edit=1;
	        }
	        //更新最新的编辑框
	        editIndex=rowIndex;
        }
	});
	
}
/**
 * @method changeShowIndex
 * @param 
 * @author xubinbin
 * Description: 改变字段的显示顺序
 */
function changeShowIndex(index,flag){
	var Data=$("#TableDataList").datagrid('getData');  //获得在页面加载的数据
	var length=Data.rows.length-1;
	var rows=Data.rows[index];   // 获得需要更新行的数据
	var id=rows.id;
	if(flag=="up"&&index==0)  // 在第一个无法上调
			return ;
	if(flag=="down"&&index==length)// 在最后一个无法下调
		    return ;
	if(flag=="up")
		switchRows(index-1,index)   //将需要上调的在index和在index-1进行交换和更新 
	if(flag=="down")
		switchRows(index,index+1)  //将需要下调的在index和在index+1进行交换和更新
}
/**
 * @method switchRows
 * @param 
 * @author xubinbin
 * Description: 交换两列
 */
function switchRows(index,value){  // index : 显示在前面的， value：显示在后面的
	var Data=$("#TableDataList").datagrid('getData');
	var tmp=""
	var indexRows=Data.rows[index];
	var valueRows=Data.rows[value];
	//需要交换的两列的显示顺序进行交换
	tmp=indexRows.ShowIndex
	indexRows.ShowIndex=valueRows.ShowIndex 
	valueRows.ShowIndex=tmp
	//先删除需要调整的两列
	$("#TableDataList").datagrid("deleteRow",index);
	$("#TableDataList").datagrid("deleteRow",value);
	//用交换两列的方式往datagrid里重新行数据
	$('#TableDataList').datagrid('insertRow',{
		index: index,	
		row: valueRows
	});
	$('#TableDataList').datagrid('insertRow',{
		index: value,	
		row: indexRows
	});
	//往后台更新两列的数据
	getEditorValue(index);
	getEditorValue(value);
	
}
/**
 * @method Doc_OnKeyDown
 * @param 
 * @author xubinbin
 * Description: 初始化回车事件
 */
function Doc_OnKeyDown(e)
{
	var key=websys_getKey(e);
	var eSrc=window.event.srcElement;
	if (key==13) {
		if(edit==0) //判断编辑器是否开启
			return 
		else{
			var selected=$("#TableDataList").datagrid("getSelected");  //获得当前点击的列对象
			var index=$("#TableDataList").datagrid('getRowIndex',selected);  //单前点击的显示序列
			getEditorValue(index);
		}
			
	}
}
/**
 * @method changeChecked
 * @param 
 * @author xubinbin
 * Description: 点击复选框事件
 */
function changeChecked(field,index){
	var FlgObj=$("#"+field+index).prop("checked"); //获得当前复选框的值
	var Data=$("#TableDataList").datagrid('getData');  //获得在页面加载的数据
	var rows=Data.rows[index];   // 获得需要更新行的数据
	rows.field=(FlgObj)?1:0  //获得当前复选框的列字段的值
	getEditorValue(index)
}
/**
 * @method getEditorValue
 * @param 
 * @author xubinbin
 * Description: 拼接有页面的更新值
 */
function getEditorValue(index){
	var exp=""
	var Data=$("#TableDataList").datagrid('getData');  //获得在页面加载的数据
	var rows=Data.rows[index];   // 获得需要更新行的数据
	var id=rows.id
	$("#TableDataList").datagrid('endEdit', index);  //关闭开启的编辑器
	//不能更新是否选中 false :没选中 true：选中
	var NotUpateFlg=$("#NotUpateFlg"+index).prop("checked");  //不能更新是否选中 false :没选中 true：选中
	var flag=(NotUpateFlg)?1:0
	exp="NotUpateFlg"+"!"+flag
	
	//差异比较关键字是否选中 false :没选中 true：选中
	var CompareFlg=$("#CompareFlg"+index).prop("checked");  
	flag=(CompareFlg)?1:0
	exp=exp+"^"+"CompareFlg"+"!"+flag
	
	//非空验证是否选中 false :没选中 true：选中
	var NullCheckFlg=$("#NullCheckFlg"+index).prop("checked");  //非空验证是否选中 false :没选中 true：选中
	flag=(NullCheckFlg)?1:0  
	exp=exp+"^"+"NullCheckFlg"+"!"+flag
	
	
	//获得数据类型的下拉的编辑器
	var ShowIndex=rows.ShowIndex; //显示顺序的值
	exp=exp+"^"+"ShowIndex"+"!"+ShowIndex
	
	//获得数据类型的下拉的编辑器
	var DataType=(rows.DataType==undefined)?"":rows.DataType
	exp=exp+"^"+"DataType"+"!"+DataType
	
	//可选值的编辑器
	var OptionVales=(rows.OptionVales==undefined)?"":rows.OptionVales
	exp=exp+"^"+"OptionVales"+"!"+OptionVales
	
	//备选1的编辑器
	var ExtStr1=(rows.ExtStr1==undefined)?"":rows.ExtStr1
	exp=exp+"^"+"ExtStr1"+"!"+ExtStr1
	 
	 //备选2的编辑器
	var ExtStr2=(rows.ExtStr2==undefined)?"":rows.ExtStr2
	exp=exp+"^"+"ExtStr2"+"!"+ExtStr2
	
	//备选3的编辑器
	var ExtStr3=(rows.ExtStr3==undefined)?"":rows.ExtStr3
	exp=exp+"^"+"ExtStr3"+"!"+ExtStr3
	
	//备选4的编辑器
	var ExtStr4=(rows.ExtStr4==undefined)?"":rows.ExtStr4
	exp=exp+"^"+"ExtStr4"+"!"+ExtStr4
	
	//备选5的编辑器
	var ExtStr5=(rows.ExtStr5==undefined)?"":rows.ExtStr5;
	exp=exp+"^"+"ExtStr5"+"!"+ExtStr5
	update(exp,id,index)
}

/**
 * @method update
 * @param 
 * @author xubinbin
 * Description: 按前台更新后台数据
 */
function update(exp,id,index){
	$m({
		ClassName:"web.InsuDlConfigCtl",
		MethodName:"updateInsuDlConfig",
		exp:exp,
		InsuDLConfigRowid:id
		},function(txtData){
		     edit=0;
		}
	);
}
 
/**
 * @method loadDataList
 * @param 
 * @author xubinbin
 * Description: 加载datagrid
 */
function loadDataList() {
	var queryParams={
		ClassName: "web.InsuDlConfigCtl",
		QueryName: "GetInsuDLConfigInfo",
		InsuType: $("#insuType").combobox('getValue'),
		TableCode: $("#TableClsName").combobox('getValue')
	}
	$.extend($("#TableDataList")
	.datagrid('options'), {
		queryParams: queryParams
	});
	$("#TableDataList").datagrid("load");
}

// 查询医保字典表下拉框(id:下拉框id,DicType:字典类型编码)
function initCombobox(id,DicType){
	$HUI.combobox('#'+id,{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
    	onBeforeLoad:function(param){
	   		param.ClassName="web.InsuTaritemsDLCtl"
	    	param.QueryName="QueryInsuDicDataInfo"
	   		param.ResultSetType="array"
	 		param.DicType=DicType       
	    },
	    onLoadSuccess:function(){
		    var Data= $('#'+id).combobox("getData");
		    var value=Data[0].DicCode
		    $('#'+id).combobox('setValue', value);
		    loadDataList();
		},
		onSelect: function(){
   		}
	});	
}
document.body.onload = BodyLoadHandler;