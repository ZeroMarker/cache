/**
 * ҽ���ֵ�ά��JS
 * Zhan 201408
 * �汾��V1.0
 * easyui�汾:1.3.2
 */
var cmenu;
var grid;
var selRowid="";
//var ROOTID='TEST2';	//������
var searchParam = {}; 
var seldictype=""; 
var tmpselRow=-1;
$(function(){
	
	GetjsonQueryUrl();
	//��ʼ��datagrid
	grid=$('#dg').datagrid({
		idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		width: '100%',
		height: 330,
		striped:true,
		fitColumns: true,
		singleSelect: true,
		columns:[[
			{field:'Rowid',title:'Rowid',width:10,hidden:true},
			{field:'INDIDDicType',title:'�ֵ����',width:60},
			{field:'INDIDDicCode',title:'����',width:50},
			{field:'INDIDDicDesc',title:'����',width:120},
			{field:'INDIDDicBill1',title:'ҽ������',width:80},
			{field:'INDIDDicBill2',title:'ҽ������',width:150},
			{field:'INDIDDicDemo',title:'��ע',width:120,align:'center'}
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
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        }
	});
	//grid.datagrid({loadFilter:pagerFilter}).datagrid('loadData', getData());	//������

	//�·���panel
	$('#sourth').panel({   
		width:'100%',   
		height:200
	});  
	//$('#sourth').append(formstr)
	/*
	$('#diccbx').combobox({   
	    url:CSPURL + 'cspfile',
	    valueField:'id',   
	    textField:'text',
	    onSelect: function(rec){  
	    	//alert(rec.text)
	    	Querydic(rec)
	    }
	});  
	*/
	//var dicurl=CSPURL+'insudicdata.csp?ARGUS='+ROOTID+SplCode+'INSUDICSYS'+SplCode+'SYS'
	var dicSelid=0
	var dicurl=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode
	var diccombox=$('#diccbx').combogrid({  
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    //panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        //rownumbers:true,
        pagination: false,
        url:dicurl,
        delay:1000,
		//queryParams:searchParam,//������Զ������ʱ�����͵Ķ������  
	    columns:[[   
	        {field:'INDIDDicCode',title:'����',width:160},  
	        {field:'INDIDDicDesc',title:'����',width:210},
	        {field:'INDIDDicDemo',title:'��ע',width:110}
	        
	    ]],
	    //fitColumns: true,
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){ 
				//getSearchParam();  
				//searchParam.key = encodeURI(decodeURIComponent($.trim(diccombox.combogrid('getText')))); 
				//searchParam.key = encodeURI($.trim(diccombox.combogrid('getText')));  
				//searchParam.key =('SYS'+ArgSpl+$.trim(diccombox.combogrid('getText')))
				//alert(searchParam)
				
				//diccombox.combogrid('grid').datagrid({ url: (dicurl+'SYS'+ArgSpl+$.trim(diccombox.combogrid('getText'))), queryParams: { qid:1}});
				
				//var cbxgrid = diccombox.combogrid('grid');  
				//$(cbxgrid).datagrid('options').url= dicurl;  
				//$(cbxgrid).datagrid('load');  
				
			},  
			query:function(q){ 
				//$(this).combogrid('grid').datagrid('unselectAll')
				var tmpq=$(this).combogrid('getText')
				//alert(dicSelid+"_"+tmpq)
				$(this).combogrid('grid').datagrid('unselectRow',dicSelid);
				dicSelid=0
				if(tmpq!="")$(this).combogrid('setText',tmpq)
				$(this).combogrid('grid').datagrid({ url: (dicurl+'SYS'+ArgSpl+cspEscape($.trim(q))+ArgSpl+"1"), queryParams: { qid:1}});
				return true;  
			}  
		},
		onSelect: function (record,selobj) {              //ѡ�д���
			dicSelid=record
			if(selobj.INDIDDicDemo!=null){
				var tmpArr=selobj.INDIDDicDemo.split("|")
				if(tmpArr.length>5){
					var tmpstr=tmpArr[5]
					var usercode=session['LOGON.USERCODE']
					if((tmpstr!="")&(tmpstr.indexOf(usercode)==-1)){
						disinput("disabled")
					}else{
						disinput(false)
					}
				}else{disinput(false)}
			}else(disinput(false))
			Querydic($('#diccbx').combogrid('grid').datagrid('getSelected'),selobj);

		},
		onShowPanel:function(){
			$(this).combogrid('grid').datagrid('unselectAll')
			$(this).combogrid('grid').datagrid({ url: (dicurl+'SYS'+ArgSpl+cspEscape($(this).combogrid('getText'))+ArgSpl+"1"), queryParams: { qid:1}});
			/*
			if(""==$.trim($(this).combogrid('getText')))
			{
				//$(this).combogrid('clear')
				$(this).combogrid('grid').datagrid({ url: (dicurl+'SYS'+ArgSpl+ArgSpl+"1"), queryParams: { qid:1}});
			}
			*/
		}
	
	}); 
	/*
	var cbxpager =diccombox.combogrid('grid').datagrid('getPager');
    $(cbxpager).pagination({
	    showPageList:false,
	    displayMsg:'',
	    pageSize:6
	});
	*/
	//disinput(true);
	//��Ȩ����
	if(BDPAutDisableFlag('btnAdd')!=true){$('btnAdd').linkbutton('disable');}
	if(BDPAutDisableFlag('btnAddup')!=true){$('btnAddup').linkbutton('disable');}
	if(BDPAutDisableFlag('btnUpdate')!=true){$('btnUpdate').linkbutton('disable');}
	if(BDPAutDisableFlag('btnDelete')!=true){$('btnDelete').linkbutton('disable');}

});
function getSearchParam(){  
	return searchParam;  
}  

//��ѯ�ֵ�����
function Querydic(rec,selobj){
	//alert(rec.INDIDDicCode)
	//queryParams���������ύ����̨ͨ��FormCollection��ȡ Ҳ����Request["ProductName"]=?��ȡ
	seldictype=cspEscape(rec.INDIDDicCode)
	if(('undefined'==seldictype)||(""==seldictype)) return
	//var tmpARGUS=ROOTID+SplCode+'INSUDICinfo'+SplCode+seldictype
	var tmpARGUS=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+seldictype+ArgSpl+ArgSpl
	grid.datagrid('unselectAll')
	grid.datagrid({ url: tmpARGUS, queryParams: {qid:1}});
	grid.datagrid('getPager').pagination('select',1);
	//alert(selobj.INDIDDicDemo)
	var titleval="";
	var titleArr;
	titleval=selobj.INDIDDicDemo
	if(titleval==null){
		titleval="����|����|ҽ������|ҽ������|��ע"
	}
	titleArr=titleval.split("|")	//����|����|ҽ������|ҽ������|��ע|
	
	if(titleArr.length<5){return;}
	if(titleArr[0].length>0)$('#codelab').html(titleArr[0])
	if(titleArr[1].length>0)$('#desclab').html(titleArr[1])
	if(titleArr[2].length>0)$('#insucodelab').html(titleArr[2])
	if(titleArr[3].length>0)$('#insudesclab').html(titleArr[3])
	if(titleArr[4].length>0)$('#notelab').html(titleArr[4])
}
//���Ӽ�¼
function AddDic(){

	clearform("")	//��������Ϣ
	//$.messager.alert('��ʾ','��д���ݺ�����"�����¼"��ť');   
}
//���±����¼
function UpdateDic(){
	/*
	if($('#code')[0].isDisabled){
		$.messager.alert('��ʾ','δ�޸�!');   
		return;
	}
	*/
	
	//�����ַ�^�Ĵ���
	$('#code').val($('#code').val().replace(/\^/g,""));
	$('#desc').attr("value",$('#desc').attr("value").replace(/\^/g,""));
	$('#insucode').attr("value",$('#insucode').attr("value").replace(/\^/g,""));
	$('#insudesc').attr("value",$('#insudesc').attr("value").replace(/\^/g,""));
	$('#note').attr("value",$('#note').attr("value").replace(/\^/g,""));
	
	if($('#code').val().indexOf("������")>=0 || $('#code').val()==""){$.messager.alert('��ʾ','��������Ϣ���ٱ���!');return;}
	if($('#desc').val().indexOf("������")>=0 || $('#desc').val()==""){$.messager.alert('��ʾ','���Ʋ���Ϊ��!');return;}
	if((seldictype=="")||(seldictype=='undefined')){
		$.messager.alert('��ʾ','��ѡ���ֵ����!');return;
	}
	
	var saveinfo=selRowid+"^"+cspUnEscape(seldictype)+"^"+$('#code').val()+"^"+$('#desc').attr("value")+"^"+$('#insucode').attr("value")+"^"+$('#insudesc').attr("value")+"^"+$('#note').attr("value");
	saveinfo=saveinfo.replace(/��������Ϣ/g,"")
	var savecode=tkMakeServerCall("web.INSUDicDataCom","Update","","",saveinfo)
	//alert(savecode)
	if(eval(savecode)>0){
		//$.messager.alert('��ʾ','����ɹ�!');  
		grid.datagrid('reload')
		grid.datagrid('unselectAll')
		clearform("")
		MSNShow('��ʾ','����ɹ���',2000) 
	}else{
		if(eval(savecode)==-1001){
			$.messager.alert('��ʾ','��'+$('#code').val()+'���˴����Ѵ�����ͬ��¼!���Ҫ�����������Ȳ�ѯ���˴���ļ�¼!');  
			return; 
		}
		$.messager.alert('��ʾ','����ʧ��!');   
	}
}
//ɾ����¼
function DelDic(){
	//if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	if(selRowid==""){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!');return;}
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDicDataCom","Delete","","",selRowid)
			if(eval(savecode)>0){
				$.messager.alert('��ʾ','ɾ���ɹ�!');   
				grid.datagrid('reload')
				selRowid="";
				grid.datagrid("getPager").pagination('refresh');
				grid.datagrid('unselectAll')
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��!');   
			}
		}else{
			return;	
		}
	});
	

}

function getcombogridValue(){ 
	//var grid=$("#cc").combogrid("grid");//��ȡ������ 
	//var row = grid.datagrid('getSelected');//��ȡ������ 
	//alert("ѡ���grid�е��������£�code:"+row.code+" name:"+row.name+" addr:"+row.addr+" col4:"+row.col4); 
} 

//����±ߵ�form
function fillform(rowIndex,rowData){
	selRowid=rowData.Rowid
	//disinput(true);
	$('#code').val(rowData.INDIDDicCode);
	$('#insucode').val(rowData.INDIDDicBill1);
	$('#desc').val(rowData.INDIDDicDesc);
	$('#insudesc').val(rowData.INDIDDicBill2);
	$('#note').val(rowData.INDIDDicDemo);

	//$('#note2').val(rowData.itemid);
}
//����±ߵ�form
function clearform(inArgs){
	
	$('#editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
	//disinput(false);
	/*
	$("#editinfo tr").find("td").each(function(i){
       if($(this).find("input[type='textbox']").length>0)
       {
           alert($(this).find("input[type='textbox']").val());
       }
       else if($(this).find("select").length>0)
       {
           alert($(this).find("select").val());
       }

     });
	*/
}
//�ı��±���ʾ��ı༭״̬
function disinput(tf){
	//return;
	$('#code').attr("disabled",tf);
	$('#insucode').attr("disabled",tf);
	$('#desc').attr("disabled",tf);
	$('#insudesc').attr("disabled",tf);
	$('#note').attr("disabled",tf);
	$('#note2').attr("disabled",tf);

}


