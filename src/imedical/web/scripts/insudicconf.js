/**
 * ҽ���ӿ��ֵ�����JS
 * FileName: insudicconf.js
 * Huang SF 2018-03-20
 * Update by tangzf 2019-8-7 ��Ժ����HISUI����
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 
//ȫ�ֱ���
var selRowid="";
var seldictype = ""; 
var tmpselRow = -1;
var PassWardFlag = "N";
var PublicDataSwitchBox = "";
$(function(){
	
	//GetjsonQueryUrl();
	
	var dicSelid=0
	//��ʼ��combogrid
	$HUI.combogrid("#diccbx",{  
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    panelHeight:300,  
	    idField:'INDIDDicCode',   
	    textField:'INDIDDicDesc', 
        //rownumbers:true,
        pagination: false,
        delay:800,
	    columns:[[   
	        {field:'INDIDDicCode',title:'����',width:160},  
	        {field:'INDIDDicDesc',title:'����',width:210},
	        {field:'INDIDDicDemo',title:'��ע',width:110}    
	    ]],
	    //fitColumns: true,
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){},  
			query:function(q){ 
				$(this).combogrid('grid').datagrid('unselectAll');
				//�첽����
				$.cm({
					ClassName:"web.INSUDicDataCom",
					QueryName:"QueryDicSys",
					CodeAndDesc:q,
					queryFlag:"",
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
		}
	}); 
	
	//��ʼ��combobox
	$HUI.combobox("#autFlag",{
		valueField:'cCode',
    	textField:'cCode',
    	panelHeight:100
	});

	//��ʼ��datagrid
	$HUI.datagrid("#dg",{
		data:[],
		fit: true,
		//idField:'dgid',
		rownumbers:true,
		width: '100%',
		striped:true,
		fitColumns:true,
		singleSelect: true,
		autoRowHeight:false,
		columns:[[
			{field:'cType',title:'�ֵ����',width:80},
			{field:'cCode',title:'����',width:80},
			{field:'cDesc',title:'����',width:150},
			{field:'cBill1',title:'ҽ������',width:80},
			{field:'cBill2',title:'ҽ������',width:150},
			//{field:'cDemo',title:'��ע',width:150,align:'center',showTip:true},
			{field:'cDemo',title:'��ע',width:150,showTip:true},
			{field:'DicAuthorityFlag',title:'��Ȩ��־',width:50},
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
			/*{field:'INDIDDicType',title:'�ֵ����',width:55},
			{field:'INDIDDicCode',title:'����',width:80},
			{field:'INDIDDicDesc',title:'����',width:150},
			{field:'INDIDDicBill1',title:'ҽ������',width:80},
			{field:'INDIDDicBill2',title:'ҽ������',width:150},
			{field:'INDIDDicDemo',title:'��ע',width:150,align:'center',showTip:true},
			{field:'INDIDDicAuthorityFlag',title:'��Ȩ��־',width:50},
			{field:'INDIDDicOPIPFlag',title:'����סԺ��־',width:50},
			{field:'INDIDDicDefaultFlag',title:'Ĭ��ʹ�ñ�־',width:50},
			{field:'INDIDDicUseFlag',title:'ʹ�ñ�־',width:50},
			{field:'INDIDDicRelationFlag',title:'���������ֵ��־',width:50},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}*/
		]],
		pageSize: 30,
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
	// ͬ��ˢ�¿���
	$HUI.switchbox('#csconflg',{
        onText:'��',
        offText:'��',
        onSwitchChange:function(e,obj){
			if(obj.value){
				var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",""); //��������Ժ��Ϊ��
			}else{
				var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",PUBLIC_CONSTANT.SESSION.HOSPID);
			}
			selectHospCombHandle();
        },
        checked:false,
        size:'small',
    })
	// ��ʾ��Ϣ
    $("#csconflg-tips").popover({
	    trigger:'hover',
	    placement:'top',
	    content:'��ʱ������������',
	    width :200,
	    
	});
	
	//�ǼǺŻس���ѯ�¼�
	$("#dicKey").keydown(function (e) {
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
});

//��ѯ�ֵ�����
function Querydic(){
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	// tangzf 2020-6-17 ʹ��HISUI�ӿ� ��������
	var QueryParam={
		ClassName:'web.INSUDicDataCom' ,
		QueryName: 'QueryDicByTypeOrCodeDesc',
		Type :$('#diccbx').combobox('getValue'), 
		dicKey :getValueById('dicKey'), 
		HospDr : $('#csconflg').switchbox('getValue') ? "" : PUBLIC_CONSTANT.SESSION.HOSPID
	}
	seldictype=$('#diccbx').combobox('getValue');
	loadDataGridStore('dg',QueryParam);
	
}
//�����ַ�����
function SplVCFormat(FStr)
{
	return  FStr.replace(/\^/g,"");
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
	/*$('#code').val($('#code').val().replace(/\^/g,""));
	$('#desc').val($('#desc').val().replace(/\^/g,""));
	$('#insucode').val($('#insucode').val().replace(/\^/g,""));
	$('#insudesc').val($('#insudesc').val().replace(/\^/g,""));
	$('#note').val($('#note').val().replace(/\^/g,""));
	$('#defUserFlag').val($('#defUserFlag').val().replace(/\^/g,""));
	$('#opIPFlag').val($('#opIPFlag').val().replace(/\^/g,""));
	$('#userFlag').val($('#userFlag').val().replace(/\^/g,""));
	$('#relUserFlag').val($('#relUserFlag').val().replace(/\^/g,""));
	$('#insucode').val($('#insucode').val().replace(/\^/g,""));
	$('#insudesc').val($('#insudesc').val().replace(/\^/g,""));
	$('#note').val($('#note').val().replace(/\^/g,""));
	*/
	$('#code').val(SplVCFormat($('#code').val()));
	$('#desc').val(SplVCFormat($('#desc').val()));
	$('#insucode').val(SplVCFormat($('#insucode').val()));
	$('#insudesc').val(SplVCFormat($('#insudesc').val()));
	$('#note').val(SplVCFormat($('#note').val()));
	$('#defUserFlag').val(SplVCFormat($('#defUserFlag').val()));
	$('#opIPFlag').val(SplVCFormat($('#opIPFlag').val()));
	$('#userFlag').val(SplVCFormat($('#userFlag').val()));
	$('#relUserFlag').val(SplVCFormat($('#relUserFlag').val()));
	$('#insucode').val(SplVCFormat($('#insucode').val()));
	$('#insudesc').val(SplVCFormat($('#insudesc').val()));
	$('#note').val(SplVCFormat($('#note').val()));
	
	//20190102 DingSH
	var tautFlag=$HUI.combobox('#autFlag').getValue();
	if (undefined==tautFlag)
	{
		$.messager.alert('��ʾ',"��ѡ����ȷ����Ȩ��ʶ",'info')
		return;
	}
	
	if ((""!=tautFlag)&&(seldictype!="SYS"))
	{
		$.messager.alert('��ʾ',"��ϵͳ(SYS)�ڵ����ֵ�����,����ѡ����Ȩ��ʶ",'info')
		return ;
	}
	
	
		
	if($('#code').val().indexOf("������")>=0 || $('#code').val()==""){$.messager.alert('��ʾ','��������Ϣ���ٱ���!','info');return;}
	if($('#desc').val().indexOf("������")>=0 || $('#desc').val()==""){$.messager.alert('��ʾ','���Ʋ���Ϊ��!','info');return;}
	if((seldictype=="")||(seldictype=='undefined')){
		$.messager.alert('��ʾ','��ѡ���ֵ����!','info');return;
	}
	
	var saveinfo=selRowid+"^"+seldictype+"^"+$('#code').val()+"^"+$('#desc').val()+"^"+$('#insucode').val()+"^"+$('#insudesc').val()+"^"+$('#note').val();
	saveinfo=saveinfo+"^"+$HUI.combobox('#autFlag').getValue()+"^"+$('#opIPFlag').val()+"^"+$('#defUserFlag').val()+"^"+$('#userFlag').val()+"^"+$('#relUserFlag').val()+"^^^";
	saveinfo=saveinfo.replace(/��������Ϣ/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall("web.INSUDicDataCom","Update","","",saveinfo)
	//alert(savecode)
	if(eval(savecode)>0){
		//$.messager.alert('��ʾ','����ɹ�!');  
		$("#dg").datagrid('reload')
		$("#dg").datagrid('unselectAll')
		clearform("")
		$.messager.alert('��ʾ','����ɹ�!','info');   
	}else{
		if(eval(savecode)==-1001){
			$.messager.alert('��ʾ','��'+$('#code').val()+'���˴����Ѵ�����ͬ��¼!���Ҫ�����������Ȳ�ѯ���˴���ļ�¼!','info');  
			return; 
		}
		$.messager.alert('��ʾ','����ʧ��!','info');   
	}
}
//ɾ����¼
function DelDic(){
	//if(BDPAutDisableFlag('btnDelete')!=true){$.messager.alert('��ʾ','����Ȩ��,����ϵ����Ա��Ȩ!');return;}
	if(selRowid=="" || selRowid<0 || !selRowid){$.messager.alert('��ʾ','��ѡ��Ҫɾ���ļ�¼!','info');return;}
	$.messager.confirm('��ȷ��','��ȷ��Ҫɾ��������¼��?',function(fb){
		if(fb){
			var savecode=tkMakeServerCall("web.INSUDicDataCom","Delete","","",selRowid)
			if(eval(savecode)>0){
				$.messager.alert('��ʾ','ɾ���ɹ�!','info');   
				$("#dg").datagrid('reload')
				selRowid="";
				$("#dg").datagrid("getPager").pagination('refresh');
				$("#dg").datagrid('unselectAll')
			}else{
				$.messager.alert('��ʾ','ɾ��ʧ��!','info');   
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
//����±ߵ�form
function fillform(rowIndex,rowData){
	// cType,cCode,cDesc,cDemo,cBill1,cBill2,selected:%Boolean,DicAuthorityFlag,DicOPIPFlag,DicUseFlag,DicRelationFlag,DicBill3,DicBill4,DicBill5
	selRowid=rowData.id
	//disinput(true);
	$('#code').val(rowData.cCode);
	$('#insucode').val(rowData.cBill1);
	$('#desc').val(rowData.cDesc);
	$('#insudesc').val(rowData.cBill2);
	$('#note').val(rowData.cDemo);
	
	$HUI.combobox('#autFlag').setValue(rowData.DicAuthorityFlag);
	//alert(rowData.selected)
	$('#defUserFlag').val(rowData.selected==true?"Y":"N");
	$('#opIPFlag').val(rowData.DicOPIPFlag);
	$('#userFlag').val(rowData.DicUseFlag);
	$('#relUserFlag').val(rowData.DicRelationFlag);
}
//����±ߵ�form
function clearform(inArgs){
	
	$('#editinfo input').each(function(){        
		$(this).val(inArgs)
	})
	selRowid="";
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
	
	$('#autFlag').attr("disabled",tf);
	$('#defUserFlag').attr("disabled",tf);
	$('#opIPFlag').attr("disabled",tf);
	$('#userFlag').attr("disabled",tf);
	$('#relUserFlag').attr("disabled",tf);

}


function addClear4Combogrid(theId,onChangeFun)
{
 var theObj = $(theId);
  
 //���ݵ�ǰֵ��ȷ���Ƿ���ʾ���ͼ��
 var showIcon = function(){  
  var icon = theObj.combogrid('getIcon',0);
  if (theObj.combogrid('getValue')){
   icon.css('visibility','visible');
  } else {
   icon.css('visibility','hidden');
  }
 };
  
 theObj.combogrid({
  //������ͼ��
  icons:[{
   iconCls:'icon-clear',
   handler: function(e){
    theObj.combogrid('clear');
   }
  }],
   
  //ֵ�ı�ʱ������ֵ��ȷ���Ƿ���ʾ���ͼ��
  onChange:function(){
   if(onChangeFun)
   {
    onChangeFun();
   }
   showIcon();
  }
   
 }); 
  
 //��ʼ��ȷ��ͼ����ʾ
 showIcon();
}

function onChangeFun(){
	
}
function authorizeClick() {
	var dgSelected=$('#dg').datagrid('getSelected');
	if(PUBLIC_CONSTANT.SESSION.HOSPID==''){
		$.messager.alert('��ʾ','��ѡ��Ժ��','info');
	}
	if(dgSelected&&dgSelected.id!=""){
		var savecode=tkMakeServerCall("web.INSUDicDataCom","Authorize",dgSelected.id,PUBLIC_CONSTANT.SESSION.HOSPID);
		if(savecode>0){
			$.messager.alert('��ʾ','��Ȩ�ɹ�','info',function(){
				Querydic($('#diccbx').combogrid('grid').datagrid('getSelected'),$('#diccbx').combogrid('grid').datagrid('getSelected'));	
			});		
		}else{
			$.messager.alert('��ʾ','��Ȩʧ�ܣ�'+savecode,'info');	
		}
	}else{
		$.messager.alert('��ʾ','��ѡ��Ҫ��Ȩ������','info');
	}
}
function selectHospCombHandle(){
	var PublicDataSwitchBox = $('#csconflg').switchbox('getValue');
	if( PublicDataSwitchBox ){
		var rtn = tkMakeServerCall("web.DHCBILLINSUCloudCommon","SetSessionData",""); 	
	}
	$('#editinfo').form('clear');
	$('#diccbx').combogrid('grid').datagrid('unselectAll');
	setValueById('diccbx','');
	seldictype='';
	selRowid = -1;
	
	//�첽����
	$.cm({
		ClassName:"web.INSUDicDataCom",
		QueryName:"QueryDicSys",
		CodeAndDesc:'',
		queryFlag:"",
		rows:1000
	},function(jsonData){		
		$('#diccbx').combogrid('grid').datagrid('loadData',jsonData.rows);
	});	
	
	//����grid
	var selobj ={
			INDIDDicCode : '',
			INDIDDicDemo : null
	}
	Querydic(selobj,selobj);
	//��Ȩ��־
	var comboJson=$.cm({
	    ClassName:"web.INSUDicDataCom",
	    QueryName:"QueryDic",
	    Type:"InsuDicAuthorityFlag",
	    Code:""
	 },false)
	 
	 setTimeout(function(){
		$HUI.combobox("#autFlag").loadData(comboJson.rows); 
	},100)
}
$('.hisui-linkbutton').bind('click',function(){
	 switch (this.id){ 
	    case "btnUpdate" : // ����
	    	if(PassWardFlag == "N"){
		    	$.messager.prompt("��ʾ", "����������", function (r) { // prompt �˴���Ҫ����Ϊ��������
					if (r) {
						PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
						if(PassWardFlag=='Y') UpdateDic(); 
						else{
							$.messager.alert('����','�������','error');	
						}
					} else {
						return false;
					}
				})
	    	}else{
	    		UpdateDic(); 
	    	}
	    	break;
	    case "btnDelete" : //ɾ��
	    	if(PassWardFlag == "N"){
		    	$.messager.prompt("��ʾ", "����������", function (r) { // prompt �˴���Ҫ����Ϊ��������
					if (r) {
						PassWardFlag = tkMakeServerCall("web.INSUDicDataCom","CehckPassWard",r,"");
						if(PassWardFlag=='Y') DelDic(); 
						else{
							$.messager.alert('����','�������','error');	
						}
					} else {
						return false;
					}
				})
	    	}else{
	    		DelDic(); 
	    	}
	    	break;
	    case "btnClear" :
	    	clearform();
	    	break;	
	    default :
	    	break;
	    }
		
}) 
