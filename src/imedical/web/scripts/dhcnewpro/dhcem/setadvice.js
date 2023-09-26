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
		 commonQuery({'datagrid':'#datagrid','formid':'#toolbar'}); //���ò�ѯ
	 }) //hxy ed */ //hxy 2020-05-26 ע��
	 
	 hospComp = GenHospComp("DHC_EmDocOrderCat");  //hxy 2020-05-26 st
     query(); //��ʼ��Ĭ�ϲ�ѯ
	 hospComp.options().onSelect = function(){///ѡ���¼�
		query();
	 }//ed
});

function addRow(){
	var HospDr=hospComp.getValue(); //hxy 2020-05-26
	commonAddRow({'datagrid':'#datagrid',value:{'docId':"",'activeFlag':'Y','hospDesc':HospDr,'hospDr':HospDr}}); //hxy 2019-07-26 LgHospID //2020-05-26 LgHospID->HospDr
	editRow=0;
}
//˫���༭
function onClickRow(index,row){
	CommonRowClick(index,row,"#datagrid");
	editRow = index;
}

function save(){
	if(!endEditing("#datagrid")){
		$.messager.alert("��ʾ","��༭��������!");
		return;
	 }
	
	var dataArr = [],hasRepeatData="";
	var $row = $('.datagrid-view2 > .datagrid-body').find('tr');
	$row.each(function(i,obj){
		var oecDr = getValueByField(obj,"oecDr");
		if(oecDr==""){return true;} //hxy 2020-05-26 $row.length ��ʵ�ʴ�
		var activeFlag = getValueByField(obj,"activeFlag"); 
		var hospDr = getValueByField(obj,"hospDr");
		var item = oecDr+"^"+activeFlag+"^"+hospDr;
		if(isHasItmInArr(dataArr,item)) hasRepeatData=i;
		dataArr.push(item);
	});
	
	
	if(hasRepeatData!=""){
		$('#datagrid').datagrid('load');
		$.messager.alert("��ʾ","�����������"+hasRepeatData+"���ظ���");
		return;
	}
	/*
	
	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
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
				$.messager.alert("��ʾ","����ɹ�!");
				$('#datagrid').datagrid('reload');				
			}else if(ret==1){
				$.messager.alert("��ʾ","����ʧ�ܣ������ظ���");
			}else{
				$.messager.alert("��ʾ","����ʧ��!ʧ�ܴ���:"+ret);
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
		$.messager.alert('��ʾ','��ѡһ��ɾ��');
		return;
	}
	$.messager.confirm('ȷ��','��ȷ����Ҫɾ����¼��',function(r){    
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
	html=html+"<span class='l-btn-left'><span class='icon icon-up l-btn-icon-left'>&nbsp;</span><span>����</span></span>"  //hxy 2018-10-22 ͼ��
	html=html+"</a>"
	html=html+"<a style='margin-left:10px' class='easyui-linkbutton l-btn l-btn-plain' onclick='javascript:moveDown("+index+")'>" //hxy �Ӽ��10
	html=html+"<span class='l-btn-left'><span class='icon icon-down l-btn-icon-left'>&nbsp;</span><span>����</span></span>"  //hxy 2018-10-22 ͼ��
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

