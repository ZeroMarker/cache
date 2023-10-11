///****************************************
//*	Author: 		Sunhuiyong
//*	Create: 		2022/07/15
//*	Description:	通用名关联ICD-项目数据采集
///****************************************
/// 页面初始化函数
var DicCode="";
var DicDesc="";
var DicRowID="";
var spac  = "^"	 /// 分隔符
var rowFlag = "[row]"	 /// 分隔符
var mDel1 = "^"  //String.fromCharCode(1);  /// 分隔符
var mDel2 = "@@"  //String.fromCharCode(2);
function initPageDefault(){
	InitLinkList();
	InitCombobox();
}
/// 初始化关联表
function InitLinkList(){
	// s title="num^itmCode^itmProName^itmGeneName^itmIngre^itmExcipient^itmForm^itmLibary^errMsg"

	var  columns=[[   
			{field:'Loc',title:'科室',width:150,align:'center'}, 
	   		{field:'Gen',title:'通用名',width:150,align:'center'},
	       	{field:'Dia',title:'诊断',width:100,align:'center'},    
	     	{field:'DiaGen',title:'通用名+诊断',width:50,align:'center',sortable:'true',sorter:mySort}, 
	     	{field:'Lv',title:'通用名+诊断/该通用名下所有诊断',width:120,align:'center',sortable:'true',sorter:mySort}, 
	     	{field:'Lv2',title:'通用名+诊断/该通用名下所有处方',width:120,align:'center',sortable:'true',sorter:mySort},
	     	{field:'Operating',title:'导入知识库',width:100,align:'center',formatter:SetCellOper}   
	        
	    ]]
	
	///  定义datagrid
	var option = {		
		toolbar:'#toolbar',
		border:false,
	    rownumbers:true,
	    fitColumns:true,
	    singleSelect:true,
	    pagination:true,
	    pageSize:500,
	    pageList:[500,1000,5000,10000],
	    fit:true,	
	    remoteSort:false,
	    //multiSort:true,
	    //checkbox:true,
	    onDblClickRow: function (rowIndex, rowData) {			
		
        },
	    onLoadSuccess: function (data) { //数据加载完毕事件
     
        }
	};	
	
	var uniturl = $URL+"?ClassName=web.DHCCKBGenDrugLinkIcd&MethodName=GetDrugLinkIcdList";
	new ListComponent('linklist', columns, uniturl, option).Init();
}
///设置操作明细连接
function SetCellOper(value, rowData, rowIndex){

	var btn = "<img class='mytooltip' title='导入' onclick=\"ImportLinkGenRule('"+rowData.Gen+"','"+rowData.Dia+"','"+rowData.Loc+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png' style='border:0px;cursor:pointer'>" 

 return btn;  

}
//导入知识库通用名规则
function ImportLinkGenRule(Gen,Dia,Loc)
{
	//判断是否该规则已经存在
	//判断是否存在通用名适应症规则
	
	//如果存在则直接插入一条疾病细信息
	//如果不存在则插入通用名适应症规则
	var hospDesc=$HUI.combobox("#HospId").getText();   //shy 2020-12-4 添加匹配项
	var hospDescStr=hospDesc;
	
	runClassMethod("web.DHCCKBGenDrugLinkIcd","ImportICDLink",{"Gen":Gen,"Dia":Dia,"Loc":Loc,"LoginInfo":LoginInfo,"HospStr":hospDescStr},function(getString){
					if (getString == 0){
						$.messager.alert("提示","导入规则成功！")
					}else if(getString == -1){
						$.messager.alert("提示","该适应症已经存在通用名规则下！")
					}else if(getString == 1){
						$.messager.alert("提示","该通用名下存在经验用药规则，已添加该疾病到规则下！")
					}else{
						$.messager.alert("提示","导入失败！")
					}
			},'text',false);
	
	
}
/// 初始化LookUp
function InitCombobox(){
    
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#HospId",{
	     url:uniturl,multiple:true,selectOnNavigation:false,editable:true,
	     valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(ret){
							
								var hospDesc=$HUI.combobox("#HospId").getValues();   //shy 2020-12-4 添加匹配项
								var hospDescStr=""
								for(var i=0;i<hospDesc.length;i++)
								{
									if(hospDescStr=="")
									{
										hospDescStr=hospDesc[i];
									}else
									{
										hospDescStr=hospDescStr+"^"+hospDesc[i];
									}
								}
														
							var uniturl = $URL+"?ClassName=web.DHCCKBGenDrugLinkIcd&MethodName=GetComLoc&HospStr="+hospDescStr  
						    $HUI.combobox("#queryloc",{
							     url:uniturl,multiple:false,selectOnNavigation:false,editable:true,
							    			    valueField:'value',
												textField:'text',
												panelHeight:"150",
												mode:'remote',
												onSelect:function(ret){
													
												}
							   })
													
							
						}
	   })
}


//自定义排序,解决百分数的排序不准确问题
function mySort(a,b) {
	a = a.split('/');
	b = b.split('/');
	if (a[2] == b[2]){
		if (a[0] == b[0]){
			a[1] = parseFloat(a[1]);
			b[1] = parseFloat(b[1]);
			return (a[1]>b[1]?1:-1);
		} else {
			a[0] = parseFloat(a[0]);
			b[0] = parseFloat(b[0]);
			return (a[0]>b[0]?1:-1);
		}
	} else {
		a[2] = parseFloat(a[2]);
		b[2] = parseFloat(b[2]);
		return (a[2]>b[2]?1:-1);
	}
}
function searchLinkList()
{
	//var hospDesc = $HUI.combobox("#HospId").getText();
	var hospDesc=$HUI.combobox("#HospId").getValues();   //shy 2020-12-4 添加匹配项
	var hospDescStr=""
	for(var i=0;i<hospDesc.length;i++)
	{
		if(hospDescStr=="")
		{
			hospDescStr=hospDesc[i];
		}else
		{
			hospDescStr=hospDescStr+"^"+hospDesc[i];
		}
	}
	var querypara=$("#querypara").val();
	var queryloc=$HUI.combobox("#queryloc").getValue();
	$("#linklist").datagrid("load",{"HospDesc":hospDescStr,"Querypara":querypara,"Queryloc":queryloc});	
}

//新添加导入 兼容谷歌
function formImpnew()
{
	var wb;				//读取完成的数据
	var rABS = false;	//是否将文件读取为二进制字符串
    var files = $("#filepath").filebox("files");
    if (files.length == 0){
		$.messager.alert("提示:","请选择文件后，重试！","warning");
		return;   
	} 
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
				wb = XLSX.read(btoa(fixdata(binary)), {//手动转化
					type: 'base64'
				});
			} else {
				wb = XLSX.read(binary, {
					type: 'binary'
				});
			}
    
        } catch (e) {
			$.messager.alert("提示:","文件类型不正确！","warning");
			$.messager.progress('close');
			return;
        }

		var obj = XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
		if(!obj||obj==""){
			$.messager.alert("提示:","读取文件内容为空！","warning");
			$.messager.progress('close'); 
			return;
		}
		$('#pro').progressbar({
		text:"正在处理中，请稍后...",
	    value: 0
		});
		//$.messager.progress({ title:'请稍后', msg:'数据正在导入中...' });
		var Ins = function(n){
			if (n >= obj.length){			  
				//Save();
				//$.messager.progress('close');
			}else{
							
				var TmpArr = [];
				for(var m = n; m < obj.length; m++) {	
	
					// json对象转成需要格式的数组
					var mListDataArr = JsonToArr(obj[m],mDel1);
					var num=obj[m].__rowNum__+1;
					mListDataArr.push("num"+mDel1+num)
					mListDataArr = mListDataArr.join(spac)	//{"a":1,"b":2} -> a$c(1)1 [next] b$c(1)2					
					TmpArr.push(mListDataArr+mDel2);
					
					//调用程序导入
					var ResultFlag = SaveRowData(mListDataArr,m,obj.length);
					
					if(ResultFlag!="1")
					{
						$("#linklist").datagrid('reload');
						break;	
					}
					if((m+1)==obj.length)
					{
						var hospId = $HUI.combobox("#HospId").getValue();
						var errFlag = serverCall("web.DHCCKBImportCompare","QueryLibDicMount",{"hospital":hospId,"type":DicCode})
						var dicMount=errFlag.split("^")[0];
						var constMount=errFlag.split("^")[1];
						
						
						$.messager.alert("提示","导入完成,本次导入对照关系"+obj.length+"条,字典条数:"+dicMount+" 对照条数:"+constMount+"!");
						$("#linklist").datagrid('reload');
						break;	
					}
								
				}
		
			}
		}
		Ins(0);	//从第一行开始读		
  
   }
   fileReader.readAsArrayBuffer(files[0]);	
		
}

//优化行导入（多次交互）
function SaveRowData(rowData,row,rowcount){
		/*var value = $('#pro').progressbar('getValue');
			if (value < 100){
	   		 	value = ((row)/(rowcount-1))*100;
	   		 	value =parseInt(value)
	   		 	$('#pro').progressbar('setValue', value);
			}
			*/
	//var hospDesc = $HUI.combobox("#HospId").getText();
	var hospDesc=$HUI.combobox("#HospId").getValues();   //shy 2020-12-4 添加匹配项
	if (hospDesc.length>1) 
	{
		$.messager.alert("提示","请选择一个医院导入！");
		return;
	}

	var ErrFlag = serverCall("web.DHCCKBGenDrugLinkIcd","SaveDrugLink",{"RowData":rowData,"HospDesc":hospDesc})
	return 1;
}
function JsonToArr(obj,spec){

	// 根据typeof判断对象也不太准确
	/*
	表达式	                      返回值
	typeof undefined	       'undefined'
	typeof null	               'object'
	typeof true	               'boolean'
	typeof 123	               'number'
	typeof "abc"	           'string'
	typeof function() {}	   'function'
	typeof {}	               'object'
	typeof []	               'object'
	*/
	
	var val=(Object.prototype.toString.call(obj) === '[Object Object]')?0:1;
	val=(JSON.stringify(obj) == "{}")?1:0;
	
	if (val){
		return "";
	}
	var strArr = [];
	for (k in obj){
		var tmpStr = k + spec + obj[k];		// {"test":"1"}-> test$c(1)1
		strArr.push(tmpStr);
	}
	
	return strArr;
	
}
 //清空文件上传的路径 
function clearFiles(){
      $('#filepath').filebox('clear');
     
} 
/// JQuery 初始化页面
$(function(){ initPageDefault(); })
