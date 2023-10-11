/*
Creator: 
CreatDate: 
Description: ȫ��Ԥ�����-Ԥ�����ƽ��-Ԥ�����ݲ���
CSPName: herp.budg.hisui.budgdataoper.csp
ClassName: herp.budg.common.BasicMethod--SplitCal����ȷֽ⵽�£�,
herp.budg.udata.uBudgFactSummarize--UpdSummarizeS���ϼ���Ŀ���ܣ�
herp.budg.udata.uBudgFactSummarize--DeptUpSum�����һ���ȫԺ��
 */


$(function(){//��ʼ��
    Init();
}); 

function Init(){
//Ԥ����ȵ�������
   var yearObj = $HUI.combobox("#yearCmb",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = ""
        },
        onSelect:function(data){ 
	        //console.log(JSON.stringify(data));
	        $('#schemeField').combobox('clear'); //���ԭ��������
	        var Url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem&hospid="+hospid+"&userdr="+userid+"&year="+data.year;
	        $('#schemeField').combobox('reload',Url);//���������б�����
	        $('#adjNo').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=AdjustNo&hospid="+hospid+"&userdr="+userid+"&flag=1+&year="+data.year;
	        $('#adjNo').combobox('reload',url);//���������б�����
        }
   });

 //�������Ƶ�������
   var schemeObj = $HUI.combobox("#schemeField",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:
            function(param){
	            param.str = param.q;
	            param.flag = "";
	            param.hospid = hospid;
	            param.userdr = userid;
	            param.year = $('#yearCmb').combobox('getValue');
            }
   })
    
   //Ԥ���ȵ�������
   var ChangeFlagObj =  $HUI.combobox("#ChangeFlagStore",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "�ڳ�Ԥ��"
                },{
                    'rowid': 2,
                    'name': "������Ԥ��"
                }]
     });
   
   //������ŵ�������  
   $("#ChangeFlagStore").combobox({
	       onChange:function(newvalue){
	         if(newvalue==2){
		         $("#adjNo").combobox("enable");
	          } else{
		         $("#adjNo").combobox("disable");
		      }
    }
    
    });
   var adjObj = $HUI.combobox("#adjNo",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=AdjustNo",
        mode:'remote',
        delay:200,
        valueField:'AdjustNo',    
        textField:'AdjustNo',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = 1;
            param.hospid = hospid;
            param.userdr = userid;
            param.year = $('#yearCmb').combobox('getValue');
        }
   });
 $(".combo").click(function(){
               //$(this).prev().combobox("showPanel");
               var year = $('#yearCmb').combobox('getValue');  
	       if (!year) {
	           $.messager.popover({
		       msg:'����ѡ����ȣ�',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
               return;
         }
     });
 //��ť--���Ԥ��ֽ⵽��
  $("#splitBtn").click(function(){
	  $.messager.confirm('ȷ��','ȷ�Ϸֽ���',function(t){
		 if(t){
        var year = $('#yearCmb').combobox('getValue');
        var ChangeFlag = $('#ChangeFlagStore').combobox('getValue');
        var adjNo = $('#adjNo').combobox('getValue');
        if (year == "") {
	       $.messager.popover({
		       msg:'Ԥ����Ȳ���Ϊ��!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
        if (ChangeFlag == "") {
	       $.messager.popover({
		       msg:'Ԥ���Ȳ���Ϊ��!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         }else  if ((ChangeFlag == "2") && (adjNo == "")) {
	       $.messager.popover({
		       msg:'������Ų���Ϊ��!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         $.messager.progress({
			 title: '��ʾ',
			 msg: '���ݴ�����...'
	                  });
	                  
	     var year = $('#yearCmb').combobox('getValue');
	     var schemDr = $('#schemeField').combobox('getValue');
	     var changeFlag = $('#ChangeFlagStore').combobox('getValue');
	     var adjNo = $('#adjNo').combobox('getValue');
         $.m({
            ClassName:'herp.budg.common.BasicMethod',
            MethodName:'SplitCal',
            hospid: hospid,
            splLayer: "",
            year: year,
            schemDr:schemDr,
            changeFlag:changeFlag,
            adjNo:adjNo
            },
            
            function(jsonData){
                 if(jsonData == -1){
	                $.messager.popover({
		                msg: 'Ԥ�����´�,��ֹ����!',
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});     
                }else if(jsonData == 0){
	                $.messager.popover({
		                msg: '�ֽ�ɹ���',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }else{
	                $.messager.popover({
		                msg: '�ֽ�ʧ��'+ jsonData,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              }
                $.messager.progress('close');
              }
            );
		 }
	  })
	});
	//��ť--�ϼ���Ŀ����
	$("#SummarizeButton").click(function(){
		$.messager.confirm('ȷ��','ȷ�ϻ�����',function(t){
		 if(t){ 
        var year = $('#yearCmb').combobox('getValue');
        var ChangeFlag = $('#ChangeFlagStore').combobox('getValue');
        var adjNo = $('#adjNo').combobox('getValue');
        if (year == "") {
	       $.messager.popover({
		       msg:'Ԥ����Ȳ���Ϊ��!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
        if (ChangeFlag == "") {
	       $.messager.popover({
		       msg:'Ԥ���Ȳ���Ϊ��!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
       
         $.messager.progress({
			 title: '��ʾ',
			 msg: '�������ڴ�����...'
	                  });
	                  
	     var year = $('#yearCmb').combobox('getValue');
	     var changeFlag = $('#ChangeFlagStore').combobox('getValue');
         $.m({
            ClassName:'herp.budg.udata.uBudgFactSummarize',
            MethodName:'SumNotLastItemBudg',
            hospid: hospid,
            year: year,
            changeFlag:changeFlag
            },
            
            function(SQLCODE){
                 if(SQLCODE == 0){
	                $.messager.popover({
		                msg: '���ݲ����ɹ�!',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }else{
	                $.messager.popover({
		                msg: '���ݲ���ʧ��!'+SQLCODE,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              }
                $.messager.progress('close');
              }
            )
		 }
		})
	});
	//��ť--���һ���ȫԺ
	$("#DSummarizeButton").click(function(){
		$.messager.confirm('ȷ��','ȷ�ϻ�����',function(t){
		 if(t){ 
        var year = $('#yearCmb').combobox('getValue');
        var ChangeFlag = $('#ChangeFlagStore').combobox('getValue');
        var adjNo = $('#adjNo').combobox('getValue');
        if (year == "") {
	       $.messager.popover({
		       msg:'Ԥ����Ȳ���Ϊ��!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
        if (ChangeFlag == "") {
	       $.messager.popover({
		       msg:'Ԥ���Ȳ���Ϊ��!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
       
         $.messager.progress({
			 title: '��ʾ',
			 msg: '�������ڴ�����...'
	                  });
	                  
	     var year = $('#yearCmb').combobox('getValue');
	     var changeFlag = $('#ChangeFlagStore').combobox('getValue');
         $.m({
            ClassName:'herp.budg.udata.uBudgFactSummarize',
            MethodName:'SumHospItemsYMValues',
            hospid: hospid,
            year: year,
            changeFlag:changeFlag
            },
            
            function(SQLCODE){
                 if(SQLCODE == 0){
	                $.messager.popover({
		                msg: '���ݲ����ɹ�!',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }else{
	                $.messager.popover({
		                msg: '���ݲ���ʧ��!'+SQLCODE,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              }
                $.messager.progress('close');
              }
            )
		 }
		}) 	 
	});
}	
