


var MainGridObj="",Adm=""
/*   var init = function() { */
	



 //$('#input').focus();
 $(function(){
	 $('#Code').focus();
 })

var userCode = session['LOGON.USERCODE'];
var userdr = session['LOGON.USERID'];

var frm =dhcsys_getmenuform();

var Adm=frm.EpisodeID.value;


$.m({
	ClassName:"web.CSSDTransByHis",
	MethodName:"ByAdmGetPatInfo",
	Adm:Adm
},function(txtData){
	  if(txtData!=null)  
            {  
                var vs = txtData.split('^'); 
				
            
			$('#RegNo').text(vs[0]);
			$('#patientname').text(vs[1]);
			$('#LocName').text(vs[2]);
			 $('#Code').focus();
			}
});

	/* function aa(){ */
var MainGridObj = $HUI.datagrid("#RegData",{

        url: $URL,
		queryParams: {
			ClassName: 'web.CSSDTransByHis',
			QueryName: 'GetPatientInfo', 
Adm:Adm
	
		},
        columns:[[
            //{field:'ck',checkbox:true},
            {field:'RegNo',title:'�ǼǺ�',width:100},
			{field:'PatName',title:'����',width:100},
               {field:'PatLoc',title:'����',width:100},
            {field:'label',title:'��ǩ',width:100},
            {field:'packageName',title:'����',width:100},
            {field:'CountNurseDr',title:'������',width:100},
            {field:'CountNurseTime',title:'����ʱ��',width:100},
            {field: 'rowid',title:'����',align:'center',hidden: true},
			{field:'opt',title:'����',width:100,
			formatter:function(val,row,index){
			   //var btn = '<a href="#"  onclick=Del('+index+') id="del"></a>';
			   var btn = '<a href="#"   class="aa" onclick=Del('+index+') >ɾ��</a>';
			//var btn='<a href="#" class="hisui-linkbutton" data-options="iconCls:"icon-w-find""></a>';
				//return btn;
				 //'var btn = '<a class="editcls" onclick="editRow(\''+index+'\')" href="javascript:void(0)" iconCls:"icon-w-find">�༭</a>';  
                return btn;  
			}
		}

        ]],
		onLoadSuccess:function(data){ $(".aa").linkbutton({ text:'', plain:true,iconCls:'icon-cancel' });
}
		
    });
/* 	} */

	

 



 


 
  $("#Code").keydown(function (e) {
      var curKey = e.which;
      if (curKey == 13) {
        //alert(222);
		if($("#Code").val()!="")
		{
		$.m({
	ClassName:"web.CSSDTransByHis",
	MethodName:"Insert",
	Label:$("#Code").val(),
	Adm:Adm,
	UserId:userdr
},function(txtData){
	   
	  if(txtData!=null)  
	  {
		 //alert(txtData)
		  if(txtData=="3")
		  {
			  $.messager.popover({msg: '��Ч�ı�ǩ��',type:'alert',timeout: 1000});
			  //$.messager.alert("��ʾ", "��Ч�ı�ǩ", 'info');
			  //alert("��Ч�ı�ǩ");
			  //$.messager.popover({msg: '��Ч�ı�ǩ',type:'alert'});
			  //$.messager.popover({msg: '�򵥾�ʾ��',type:'alert'});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		  else if(txtData=="1")
		  {
			   //alert("�ñ�ǩ�Ѿ�ʹ��");
			  $.messager.popover({msg: '�ñ�ǩ�Ѿ�ʹ��',type:'alert',timeout: 1000});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		  else if(txtData=="4")
		  {
			   //alert("��ǩû�����");
			  $.messager.popover({msg: '��ǩû�����',type:'alert',timeout: 1000});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		   else if(txtData=="5")
		  {
			   //alert("��ǩ������Ч��");
			     $.messager.popover({msg: '��ǩ������Ч��',type:'alert',timeout: 1000});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		   else if(txtData=="6")
		  {
			   //alert("��ǩû�з���");
			 $.messager.popover({msg: '��ǩû�з���',type:'alert',timeout: 1000});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		  else
		  {
			    MainGridObj.load({
              ClassName: 'web.CSSDTransByHis',
			QueryName: 'GetPatientInfo', 
Adm:Adm
	/* aa(); */
            });
			 $("#Code").val("");
                $('#Code').focus();
		  }
			  
	  }
           
			
			
});
	  }
	  }
      
  });
  
  function Del(index)
{
	$('#RegData').datagrid('selectRow',index);// �ؼ�������
	var row = $('#RegData').datagrid('getSelected');
	if (row){
		//alert(row.rowid);
		$.m({
	ClassName:"web.CSSDTransByHis",
	MethodName:"Delete",
	RowID:row.rowid
},function(txtData){
	 if(txtData=="0")
	 {
		  MainGridObj.load({
              ClassName: 'web.CSSDTransByHis',
			QueryName: 'GetPatientInfo', 
Adm:Adm
	
            })
		
	 }
           
});
	}
}

  
	




$('#Code').focus();



