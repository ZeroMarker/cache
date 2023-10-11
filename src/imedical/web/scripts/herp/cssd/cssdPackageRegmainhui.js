


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
            {field:'RegNo',title:'登记号',width:100},
			{field:'PatName',title:'病人',width:100},
               {field:'PatLoc',title:'科室',width:100},
            {field:'label',title:'标签',width:100},
            {field:'packageName',title:'包名',width:100},
            {field:'CountNurseDr',title:'操作人',width:100},
            {field:'CountNurseTime',title:'操作时间',width:100},
            {field: 'rowid',title:'操作',align:'center',hidden: true},
			{field:'opt',title:'操作',width:100,
			formatter:function(val,row,index){
			   //var btn = '<a href="#"  onclick=Del('+index+') id="del"></a>';
			   var btn = '<a href="#"   class="aa" onclick=Del('+index+') >删除</a>';
			//var btn='<a href="#" class="hisui-linkbutton" data-options="iconCls:"icon-w-find""></a>';
				//return btn;
				 //'var btn = '<a class="editcls" onclick="editRow(\''+index+'\')" href="javascript:void(0)" iconCls:"icon-w-find">编辑</a>';  
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
			  $.messager.popover({msg: '无效的标签！',type:'alert',timeout: 1000});
			  //$.messager.alert("提示", "无效的标签", 'info');
			  //alert("无效的标签");
			  //$.messager.popover({msg: '无效的标签',type:'alert'});
			  //$.messager.popover({msg: '简单警示！',type:'alert'});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		  else if(txtData=="1")
		  {
			   //alert("该标签已经使用");
			  $.messager.popover({msg: '该标签已经使用',type:'alert',timeout: 1000});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		  else if(txtData=="4")
		  {
			   //alert("标签没有灭菌");
			  $.messager.popover({msg: '标签没有灭菌',type:'alert',timeout: 1000});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		   else if(txtData=="5")
		  {
			   //alert("标签到了有效期");
			     $.messager.popover({msg: '标签到了有效期',type:'alert',timeout: 1000});
			   $("#Code").val("");
                $('#Code').focus();
		  }
		   else if(txtData=="6")
		  {
			   //alert("标签没有发放");
			 $.messager.popover({msg: '标签没有发放',type:'alert',timeout: 1000});
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
	$('#RegData').datagrid('selectRow',index);// 关键在这里
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



