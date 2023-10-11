/**
 * ҽ���ӿ������ֵ�����JS
 * FileName:insudicprocess.js
 * Huang SF 2018-03-20
 * Update by tangzf 2019-8-7 ��Ժ����HISUI����
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 
//ȫ�ֱ���
var cmenu;
var grid;
var selRowid="";
//var ROOTID='TEST2';	//������
var searchParam = {}; 
var seldictype=""; 
var tmpselRow=-1;
$(function(){
	
	// GetjsonQueryUrl();
	
	var dicSelid=0
	//��ʼ��combogrid
	$HUI.combogrid("#diccbx",{  
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    //panelHeight:238,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        //rownumbers:true,
        pagination: false,
        delay:500,
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
			},  
			query:function(q){ 
				$(this).combogrid('grid').datagrid('unselectAll');
				//�첽����
				$.cm({
					ClassName:"web.INSUDicDataCom",
					QueryName:"QueryDicSys",
					CodeAndDesc:q,
					queryFlag:"PRO",
					rows:1000
				},function(jsonData){
					$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
					$('#diccbx').combogrid('setText',q);
				}); 
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
			clearform();
			Querydic($('#diccbx').combogrid('grid').datagrid('getSelected'),selobj);
		},
		onShowPanel:function(){	
			/*$(this).combogrid('grid').datagrid('unselectAll'); tangzf 2020-5-26 -
			var comText=$.trim($(this).combogrid('getText'));
			//�첽����
			$.cm({
				ClassName:"web.INSUDicDataCom",
				QueryName:"QueryDicSys",
				CodeAndDesc:comText,
				queryFlag:"PRO",
				rows:1000
			},function(jsonData){		
				$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
				$('#diccbx').combogrid('setText',comText);
			}); */
		}
	
	}); 
	
	//��ʼ��datagrid
	$HUI.datagrid("#dg",{
		fit: true,
		//idField:'dgid',
		iconCls: 'icon-save',
		rownumbers:true,
		width: '100%',
		striped:true,
		fitColumns:true,
		singleSelect: true,
		autoRowHeight:false,
		columns:[[
			//{field:'cType',title:'�ֵ����',width:55},
			{field:'cCode',title:'����',width:80},
			{field:'cDesc',title:'����',width:150},
			//{field:'cBill1',title:'ҽ������',width:80},
			//{field:'cBill2',title:'ҽ������',width:150},
			{field:'cDemo',title:'��ע',width:150,align:'center',showTip:true},
			/*{field:'DicAuthorityFlag',title:'��Ȩ��־',width:50},
			{field:'DicOPIPFlag',title:'����סԺ��־',width:50},
			{field:'selected',title:'Ĭ��ʹ�ñ�־',width:50,formatter:function(val,index,rowdData){
				if(val){
					return "Y"	
				}else{
					return "N"	
				}
			}},
			{field:'DicUseFlag',title:'ʹ�ñ�־',width:50},
			{field:'DicRelationFlag',title:'���������ֵ��־',width:50},
			{field:'id',title:'id',width:10,hidden:true}
			{field:'Rowid',title:'Rowid',width:10,hidden:true},
			{field:'INDIDDicType',title:'�ֵ����',width:55,hidden:true},
			{field:'INDIDDicCode',title:'����',width:60},
			{field:'INDIDDicDesc',title:'����',width:80},
			{field:'INDIDDicBill1',title:'ҽ������',width:80,hidden:true},
			{field:'INDIDDicBill2',title:'ҽ������',width:150,hidden:true},
			{field:'INDIDDicDemo',title:'��ע',align:'center',width:250},
			{field:'INDIDDicAuthorityFlag',title:'��Ȩ��־',width:50,hidden:true},
			{field:'INDIDDicOPIPFlag',title:'����סԺ��־',width:50,hidden:true},
			{field:'INDIDDicDefaultFlag',title:'Ĭ��ʹ�ñ�־',width:50,hidden:true},
			{field:'INDIDDicUseFlag',title:'ʹ�ñ�־',width:50,hidden:true},
			{field:'INDIDDicRelationFlag',title:'���������ֵ��־',width:50,hidden:true}*/
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
	//�ǼǺŻس���ѯ�¼�
	$("#dicDemo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			Querydic();
		}
	});
	//��Ȩ����
	if(BDPAutDisableFlag('btnAdd')!=true){$('btnAdd').linkbutton('disable');}
	if(BDPAutDisableFlag('btnAddup')!=true){$('btnAddup').linkbutton('disable');}
	if(BDPAutDisableFlag('btnUpdate')!=true){$('btnUpdate').linkbutton('disable');}
	if(BDPAutDisableFlag('btnDelete')!=true){$('btnDelete').linkbutton('disable');}
	$("#dg").datagrid("loadData",{"total":"0",rows:[]}); //Zhan 20181206�����ʼ��ʱ��ʾ10����¼����,����HISUI�޸ĺ��ע�ʹ���
});

function getSearchParam(){  
	return searchParam;  
}  

//��ѯ�ֵ�����
function Querydic(){
	//alert(rec.INDIDDicCode)
	//queryParams���������ύ����̨ͨ��FormCollection��ȡ Ҳ����Request["ProductName"]=?��ȡ
	// tangzf 2020-6-17 ʹ��HISUI�ӿ� ��������
	var QueryParam={
		ClassName:'web.INSUDicDataCom' ,
		QueryName: 'QueryDicByTypeOrCodeDesc',
		Type :$('#diccbx').combobox('getValue'), 
		keyDemo:getValueById('dicDemo'),
		HospDr : PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadDataGridStore('dg',QueryParam);
	seldictype = $('#diccbx').combobox('getValue');
	/*
	if(('undefined'==seldictype)||(""==seldictype)) return
	//var tmpARGUS=ROOTID+SplCode+'INSUDICinfo'+SplCode+seldictype
	var tmpARGUS=jsonQueryUrl+'web.INSUDicDataCom'+SplCode+"GetDicJSONInfo"+SplCode+seldictype+ArgSpl+ArgSpl
	$("#dg").datagrid('unselectAll')
	$("#dg").datagrid({ url: tmpARGUS, queryParams: {qid:1}});
	$("#dg").datagrid('getPager').pagination('select',1);
	//alert(selobj.INDIDDicDemo)
	var titleval="";
	var titleArr;
	titleval=selobj.INDIDDicDemo
	if(titleval==null){
		titleval="����|����|��ע|"
	}
	titleArr=titleval.split("|")	//����|����|ҽ������|ҽ������|��ע|
	
	if(titleArr.length<3){return;}
	if(titleArr[0].length>0)$('#codelab').html(titleArr[0])
	if(titleArr[1].length>0)$('#desclab').html(titleArr[1])
	if(titleArr[2].length>0)$('#notelab').html(titleArr[3])*/
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
	$('#desc').val($('#desc').val().replace(/\^/g,""));
	$('#note').val($('#note').val().replace(/\^/g,""));
		
	if($('#code').val().indexOf("������")>=0 || $('#code').val()==""){$.messager.alert('��ʾ','��������Ϣ���ٱ���!');return;}
	if($('#desc').val().indexOf("������")>=0 || $('#desc').val()==""){$.messager.alert('��ʾ','���Ʋ���Ϊ��!');return;}
	if((seldictype=="")||(seldictype=='undefined')){
		$.messager.alert('��ʾ','��ѡ���ֵ����!');return;
	}
	
	var saveinfo=selRowid+"^"+seldictype+"^"+$('#code').val()+"^"+$('#desc').val()+"^^^"+$('#note').val();
	saveinfo=saveinfo.replace(/��������Ϣ/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall("web.INSUDicDataCom","UpdateIn","","",saveinfo)
	//alert(savecode)
	if(eval(savecode)>0){
		//$.messager.alert('��ʾ','����ɹ�!');  
		$("#dg").datagrid('reload')
		$("#dg").datagrid('unselectAll')
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
	if(selRowid==""|| selRowid<0 || !selRowid){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDicDataCom","Delete","","",selRowid)
			if(eval(savecode)>0){
				$.messager.alert('��ʾ','ɾ���ɹ�!');   
				$("#dg").datagrid('reload')
				selRowid="";
				$("#dg").datagrid("getPager").pagination('refresh');
				$("#dg").datagrid('unselectAll')
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��!');   
			}
		}else{
			return;	
		}
	});
	
	var okSpans=$(".l-btn-text");
	var len=okSpans.length;
	for(var i=0;i<len;i++){
		var $okSpan=$(okSpans[i]);
		var okSpanHtml=$okSpan.html();
		if(okSpanHtml=="Cancel"|| okSpanHtml=="ȡ��"){
			$okSpan.parent().parent().trigger("focus");
		}
	}

}

function getcombogridValue(){ 
	//var grid=$("#cc").combogrid("grid");//��ȡ������ 
	//var row = grid.datagrid('getSelected');//��ȡ������ 
	//alert("ѡ���grid�е��������£�code:"+row.code+" name:"+row.name+" addr:"+row.addr+" col4:"+row.col4); 
} 

//����±ߵ�form
function fillform(rowIndex,rowData){
	selRowid=rowData.id
	//disinput(true);
	$('#code').val(rowData.cCode);
	$('#desc').val(rowData.cDesc);
	$('#note').val(rowData.cDemo);
}
//����±ߵ�form
function clearform(inArgs){
	
	$('#editForm1 input').each(function(){        
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
	$('#desc').attr("disabled",tf);
	$('#note').attr("disabled",tf);

}
function selectHospCombHandle(){
	$('#diccbx').combogrid('grid').datagrid('unselectAll');
	setValueById('diccbx','');
	seldictype='';
	selRowid = '';
	selRowid = -1;
	//����grid
	var selobj ={
			INDIDDicCode : '',
			INDIDDicDemo : null
	}
	Querydic(selobj,selobj);
	//�첽����
	$.cm({
		ClassName:"web.INSUDicDataCom",
		QueryName:"QueryDicSys",
		CodeAndDesc:'',
		queryFlag:"PRO",
		rows:1000
	},function(jsonData){		
		$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
	});	
	
}