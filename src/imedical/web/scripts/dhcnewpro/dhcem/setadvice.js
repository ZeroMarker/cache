///CreatDate:  2017-03-27
///Author:    qiaoqingao

var editRow=""

$(function(){ 

	 /*$('#hospDrID').combobox({ //hxy 2019-07-18 st
	 	url:'dhcapp.broker.csp?ClassName=web.DHCEMCommonUtil&MethodName=GetHospDs',
	 	valueField:'value',
		textField:'text',   
		panelHeight:'auto'
	 }) 
	 
	 $('#queryBTN').on('click',function(){
		 commonQuery({'datagrid':'#datagrid','formid':'#toolbar'}); //调用查询
	 }) //hxy ed */ //hxy 2020-05-26 注释
	 
	 hospComp = GenHospComp("DHC_EmDocOrderCat");  //hxy 2020-05-26 st
     query(); //初始化默认查询
	 hospComp.options().onSelect = function(){///选中事件
		query();
	 }//ed
});

function addRow(){
	var HospDr=hospComp.getValue(); //hxy 2020-05-26
	commonAddRow({'datagrid':'#datagrid',value:{'docId':"",'activeFlag':'Y','hospDesc':HospDr,'hospDr':HospDr}}); //hxy 2019-07-26 LgHospID //2020-05-26 LgHospID->HospDr
	editRow=0;
}
//双击编辑
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
	editRow = index;
}

function save(){
	if(!endEditing("#datagrid")){
		$.messager.alert("提示","请编辑必填数据!");
		return;
	 }
	
	var dataArr = [],hasRepeatData="";
	var $row = $('.datagrid-view2 > .datagrid-body').find('tr');
	$row.each(function(i,obj){
		var oecDr = getValueByField(obj,"oecDr");
		if(oecDr==""){return true;} //hxy 2020-05-26 $row.length 比实际大
		var activeFlag = getValueByField(obj,"activeFlag"); 
		var hospDr = getValueByField(obj,"hospDr");
		var item = oecDr+"^"+activeFlag+"^"+hospDr;
		if(isHasItmInArr(dataArr,item)) hasRepeatData=i;
		dataArr.push(item);
	});
	
	
	if(hasRepeatData!=""){
		$('#datagrid').datagrid('load');
		$.messager.alert("提示","新增数据与第"+hasRepeatData+"行重复！");
		return;
	}
	/*
	
	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("提示","没有待保存数据!");
		return;
	}
	
	var dataList = [];
	for(var i=0;i<rowsData.length;i++){
		var tmp=rowsData[i].docId +"^"+ rowsData[i].oecDr +"^"+ rowsData[i].activeFlag +"^"+ rowsData[i].hospDr;
		dataList.push(tmp);
	}
	*/
	runClassMethod(
		"web.DHCEMDocOrderCat",
		"saveTable",
		{
			listData:dataArr.join("$$"),
			hospId:hospComp.getValue() //hxy 2020-05-26 LgHospID->hospComp.getValue()
		},function(ret){
			if(ret==0){
				$.messager.alert("提示","保存成功!");
				$('#datagrid').datagrid('reload');				
			}else if(ret==1){
				$.messager.alert("提示","保存失败，代码重复！");
			}else{
				$.messager.alert("提示","保存失败!失败代码:"+ret);
			}
		},"text") 
}

function isHasItmInArr(arrData,itm){
	var ret=false;
	for (var i in arrData){
		if(arrData[i]==itm) ret=true;
	}
	return ret;
}

function cancel(){
	
	if ($("#datagrid").datagrid('getSelections').length != 1) {
		$.messager.alert('提示','请选一个删除');
		return;
	}
	$.messager.confirm('确认','您确认想要删除记录吗？',function(r){    
    if (r){
	    var row =$("#datagrid").datagrid('getSelected');
		runClassMethod("web.DHCEMDocOrderCat","RemoveDocOrderCat",{'Id':row.docId},function(data){ $('#datagrid').datagrid('load'); })
    }    
}); 
}

function cellStyler(value,row,index){
	if(value==undefined){   //2016-07-18 qunianpeng
		value="" ;
	}	
	html="<a class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveUp("+index+")'>"
	html=html+"<span class='l-btn-left'><span class='icon icon-up l-btn-icon-left'>&nbsp;</span><span>上移</span></span>"  //hxy 2018-10-22 图标
	html=html+"</a>"
	html=html+"<a style='margin-left:10px' class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>" //hxy 加间距10
	html=html+"<span class='l-btn-left'><span class='icon icon-down l-btn-icon-left'>&nbsp;</span><span>下移</span></span>"  //hxy 2018-10-22 图标
	html=html+"</a>"+value
	return html;
}

function moveUp(index){move(true,index)}

function moveDown(index){move(false,index)}

function move(isUp,index) {

		var rows=$('#datagrid').datagrid('getData')

		//if((isUp)&&(index==0)){
		//	return;
		//}
		if(!(isUp)&&(index==rows.length)){
			return;
		}

		
		var $view = $('div.datagrid-view');
		var $row = $view.find('tr[datagrid-row-index=' + index + ']');		
	    if (isUp) {
	            $row.each(function(){
	                    var prev = $(this).prev();
	                    prev.length && $(this).insertBefore(prev);
	    });
	    } else {
	            $row.each(function(){
	                    var next = $(this).next();
	                   next.length && $(this).insertAfter(next);
	            });
	    }
}


function getValueByField(obj,field){		
	 ret=""  
	 $(obj).find('td').each(function(j,o){
		 	if($(o).attr("field")==field){
				ret=$(o).find('div').html(); 	
			}
	 });
	 return ret;
}

function query(){
	var HospDr=hospComp.getValue();
	$("#datagrid").datagrid( { 
		url:'dhcapp.broker.csp?ClassName=web.DHCEMDocOrderCat&MethodName=queryCatList&hospDrID='+HospDr
	})
}

