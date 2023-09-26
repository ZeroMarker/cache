 /*
 * FileName: dhcbill.pkg.insudicitem.js
 * User:		LinCheng
 * Date:		2019-09-24
 * Function:	套餐字典项目配置JS
 * Description: 
*/
//全局变量
//var HospDr=session['LOGON.HOSPID'];
var CreatUser=session['LOGON.USERID'];
var UpdateUser=session['LOGON.USERID'];
var tDicCode="";
var tmpselRow=-1;
var selRowid="";
var CreatDates="";
var CreatUsers="";
$(function(){
	QueryDic(); //字典类型
	initPkgGrpList(); //列表
	tclearform(); //清屏
	});
 

function QueryDic(){
$HUI.combogrid("#diccbx",{   //字典类型
        panelWidth: 600,
        validType: ['checkInsuInfo'],
        delay: 300,
        mode: 'remote',
        method: 'GET',
        fitColumns: true,
        pagination: true,
        valueField:'KeyWords',
        textField:'DicDesc',
        data: [],
        columns: [
            [
             {field: 'DicCode', title: '字典类型代码', width: 230},
             {field: 'DicDesc', title: '字典类型名称', width: 230},
             {field: 'DicDemo', title: '备注', width: 120}]
        ],
        url:$URL,
        defaultFilter:4,
        onBeforeLoad:function(para){
            para.ClassName='BILL.PKG.BL.Dictionaries'
            para.QueryName='QueryDicSys'
            para.KeyWords=para.q;
            para.AuthFlag = "";
            para.HospDr =PUBLIC_CONSTANT.SESSION.HOSPID;
            
        },    
        onLoadSuccess:function(){
        
        },
        onLoadError:function(err){
            
        },
        onSelect:function(Index, Data){
         tDicCode=Data.DicCode;
         initPkgGrpList();
        
        }    
    })


}




function initPkgGrpList() {  //列表
	$HUI.datagrid("#dg",{
		url:$URL + "?ClassName=BILL.PKG.BL.Dictionaries&QueryName=QueryDic&DictType="+tDicCode+"&DicCode="+""+"&HospDr="+PUBLIC_CONSTANT.SESSION.HOSPID,
		fit: true,
		idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		width: '100%',
		striped:true,
		fitColumns:true,
		singleSelect: true,
		autoRowHeight:false,
		columns:[[
			{field:'Id',title:'Rowid',width:10,hidden:true},
			{field:'Type',title:'字典类型',width:150},
			{field:'Code',title:'代码',width:150},
			{field:'Desc',title:'名称',width:200},
			{field:'Mark',title:'备注',width:150},
			{field:'CreatDate',title:'创建日期',width:150},
			{field:'CreatTime',title:'创建时间',width:100},
			{field:'UpdateDate',title:'修改日期',width:150},
			{field:'UpdateTime',title:'修改时间',width:100},
			{field:'CreatUserDr',title:'创建人DR',width:150,hidden:true},
			{field:'CreatUser',title:'创建人',width:150},
			{field:'UpdateUserDr',title:'修改人DR',width:150,hidden:true},
			{field:'UpdateUser',title:'修改人',width:150},
			{field:'Hospital',title:'医院',width:250},
			{field:'ActiveStatus',title:'有效标志',width:150,
			formatter:function(value,data,row){
					value=='Y'?value='有效':value='无效';
					return value;}
			
			},
		
		]],
		pageSize: 10,
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	      if(tmpselRow==rowIndex){
		        clearform("")
		        tmpselRow=-1
		        $(this).datagrid('unselectRow',rowIndex)
		    }else{
			    fillform(rowIndex,rowData)
			    tmpselRow=rowIndex
			}  
            
        },
        onselect: function(Index,Data) {
        	
        }
	});	
}

//更新保存记录
function UpdateDic(){
     
	//特殊字符^的处理
	$('#code').val($('#code').val().replace(/\^/g,""));
	$('#desc').val($('#desc').val().replace(/\^/g,""));
		
	if($('#code').val().indexOf("请输入")>=0 || $('#code').val()==""){$.messager.alert('提示','请输入信息后再保存!');return;}
	if($('#desc').val().indexOf("请输入")>=0 || $('#desc').val()==""){$.messager.alert('提示','名称不能为空!');return;}
	if(CreatDates==""){
		var saveinfo=selRowid+"^"+$('#code').val()+"^"+$('#desc').val()+"^^^^^"+CreatUser+"^^"+$('#mark').val()+"^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+tDicCode+"^"+"Y";
	//alert(saveinfo)
	var savecode=tkMakeServerCall("BILL.PKG.BL.Dictionaries","Save",saveinfo)
	
	if(savecode>0){
		$.messager.alert('提示','保存成功!');  
		clearform("")
	
	}else{
		if(savecode==-1){
			$.messager.alert('提示','【'+$('#code').val()+'】此代码已存在相同记录!如果要更新内容请先查询出此代码的记录!');  
			return; 
		}
		$.messager.alert('提示','保存失败!');   
	}}
	else{
	var saveinfo=selRowid+"^"+$('#code').val()+"^"+$('#desc').val()+"^^^^^"+CreatUsers+"^"+UpdateUser+"^"+$('#mark').val()+"^"+PUBLIC_CONSTANT.SESSION.HOSPID+"^"+tDicCode+"^"+"Y";
	//alert(saveinfo)
	var savecode=tkMakeServerCall("BILL.PKG.BL.Dictionaries","Save",saveinfo)
	
	if(savecode>0){
		$.messager.alert('提示','保存成功!');  
		clearform("")
	
	}else{
		if(savecode==-1){
			$.messager.alert('提示','【'+$('#code').val()+'】此代码已存在相同记录!如果要更新内容请先查询出此代码的记录!');  
			return; 
		}
		$.messager.alert('提示','保存失败!');   
	}}
	initPkgGrpList();
}

function tclearform() {
	//清屏
	$('#btnAdd').bind('click', function () {
	clearform("")	
});
}
//填充下边的form	
function fillform(rowIndex,rowData){
	selRowid=rowData.Id
	CreatDates=rowData.CreatDate
	CreatUsers=rowData.CreatUserDr
	$('#code').val(rowData.Code);
	$('#desc').val(rowData.Desc);
	$('#mark').val(rowData.Mark);
}
//清除下边的form
function  clearform(inArgs){
	$('#editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
	CreatDates="";
	CreatUsers="";
}
//改变下边显示框的编辑状态
function disinput(tf){
	//return;
	$('#code').attr("disabled",tf);
	$('#desc').attr("disabled",tf);
	$('#mark').attr("disabled",tf);

}

// 院区combogrid选择事件
function selectHospCombHandle(){
	QueryDic(); //字典类型
	initPkgGrpList(); //列表
	tclearform(); //清屏

}