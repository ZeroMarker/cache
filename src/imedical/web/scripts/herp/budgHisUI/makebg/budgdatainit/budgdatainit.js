$(function(){//��ʼ��
    Init();
}); 


function Init(){
	$.messager.popover({
		       msg:'���ο���ʷ��������ڵ�ƽ������ΪԤ�������ȵ�Ԥ��������ݡ�',
		       type:'info',
		       timeout: 0,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"1000",
		              left:230,
		              top:170,
		              width:650
		              }});

//Ԥ�������ȵ�������
   var cyearObj = $HUI.combobox("#cyearCombo",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = ""
        
        }
   });
   
//��ʷ���������ʼ���������
    var byearObj = $HUI.combobox("#byearCombo",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = ""
        }
   });
   
//��ʷ������Ƚ������������
   var eyearObj = $HUI.combobox("#eyearCombo",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = ""
        }
   });
//Ԥ�������·ݿ�ʼ�µ�������
   var Date1Obj =  $HUI.combobox("#Date1Combo",{  
        valueField:'rowid',    
        textField:'name',
        data: [{
	                'rowid': 1,
                    'name': "1��"
                },{
	                'rowid': 2,
	                'name': "2��"
	            },{
		            'rowid': 3,
		            'name': "3��" 
		        },{
	                'rowid': 4,
                    'name': "4��"
                },{
	                'rowid': 5,
	                'name': "5��"
	            },{
		            'rowid': 6,
		            'name': "6��" 
		        },{
		            'rowid': 7,
		            'name': "7��" 
		        },{
	                'rowid': 8,
                    'name': "8��"
                },{
	                'rowid': 9,
	                'name': "9��"
	            },{
		            'rowid': 10,
		            'name': "10��" 
		        },{
		            'rowid': 11,
		            'name': "11��" 
		        },{
	                'rowid': 12,
                    'name': "12��"
                }]
     });
   //Ԥ�������·ݽ����µ�������
   var Date2Obj =  $HUI.combobox("#Date2Combo",{  
        valueField:'rowid',    
        textField:'name',
        data: [{
	                'rowid': 1,
                    'name': "1��"
                },{
	                'rowid': 2,
	                'name': "2��"
	            },{
		            'rowid': 3,
		            'name': "3��" 
		        },{
	                'rowid': 4,
                    'name': "4��"
                },{
	                'rowid': 5,
	                'name': "5��"
	            },{
		            'rowid': 6,
		            'name': "6��" 
		        },{
		            'rowid': 7,
		            'name': "7��" 
		        },{
	                'rowid': 8,
                    'name': "8��"
                },{
	                'rowid': 9,
	                'name': "9��"
	            },{
		            'rowid': 10,
		            'name': "10��" 
		        },{
		            'rowid': 11,
		            'name': "11��" 
		        },{
	                'rowid': 12,
                    'name': "12��"
                }]
     });
   //��ť--���ݳ�ʼ��
   $("#dataInitButton").click(function(){
	   $.messager.confirm('ȷ��','ȷ�ϳ�ʼ����',function(t){
		 if(t){ 
        var cYear = $('#cyearCombo').combobox('getValue');
        if (cYear == "") {
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
         $.messager.progress({
			 title: '��ʾ',
			 msg: '���ڳ�ʼ�������Ժ򡭡�'
	                  });
         $.m({
            ClassName:'herp.budg.udata.uBudgDataInit',
            MethodName:'BudgInit',
            Year:cYear,
            hospid:hospid
            },
            
            function(jsonData){
                if(jsonData == 0){
	                $.messager.popover({
		                msg: '��ʼ���ɹ���',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              
                }else{
	                $.messager.popover({
		                msg: 'jsonData',
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }
                $.messager.progress('close');
              }
            );
		 }})
	});
	
//��ť--�ο����ݼ���
 $("#referDataButton").click(function(){
	 $.messager.confirm('ȷ��','ȷ�ϼ�����',function(t){
		 if(t){ 
        var cYear = $('#cyearCombo').combobox('getValue');
        var bYear = $('#byearCombo').combobox('getValue');
        var eYear = $('#eyearCombo').combobox('getValue');
        
        if (cYear == "") {
	       $.messager.popover({
		       msg:'Ԥ����Ȳ���Ϊ��!',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (bYear == "") {
	       $.messager.popover({
		       msg:'��ʷ��ʼ��ݲ���Ϊ��',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (eYear == "") {
	       $.messager.popover({
		       msg:'��ʷ������ݲ���Ϊ��',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (bYear > eYear) {
	       $.messager.popover({
		       msg:'��ʷ��ʼ��ݲ��ܴ�����ʷ�������',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (cYear <= eYear) {
	       $.messager.popover({
		       msg:'Ԥ�����Ӧ������ʷ�������',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         
       $.messager.progress({
			title: '�ο����ݼ���',
			msg: '�������ڴ�����...���Ժ�'
	                  });
         $.m({
            ClassName:'herp.budg.udata.uBudgDataInit',
            MethodName:'referDataInit',
            hospid:hospid,
            cYear:cYear,
            bYear:bYear,
            eYear:eYear
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
		                msg: '���ݲ����ɹ���',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }else{
	                $.messager.popover({
		                msg: 'jsonData',
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              }
                $.messager.progress('close');
              }
            );
		 }})
	});
	///��ť--Ԥ�����ݼ���
   $("#splitBtn").click(function(){
	   $.messager.confirm('ȷ��','ȷ�ϼ�����',function(t){
		 if(t){ 
        var cYear = $('#cyearCombo').combobox('getValue');
        var bYear = $('#byearCombo').combobox('getValue');
        var eYear = $('#eyearCombo').combobox('getValue');
        if (cYear == "") {
	       $.messager.popover({
		       msg:'Ԥ����Ȳ���Ϊ��!',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
          if (bYear == "") {
	       $.messager.popover({
		       msg:'��ʷ��ʼ��ݲ���Ϊ��',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (eYear == "") {
	       $.messager.popover({
		       msg:'��ʷ������ݲ���Ϊ��',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         
         $.messager.progress({
			 title: '��ʾ',
			 msg: '�������ڴ�����...���Ժ�'
	                  });
         $.m({
            ClassName:'herp.budg.udata.uBudgDataInit',
            MethodName:'CalMonSeaHisLaVal',
            hospid:hospid,
            cYear:cYear,
            bYear:bYear,
            eYear:eYear
            },
            
            function(jsonData){
                if(jsonData == 0){
	                $.messager.popover({
		                msg: '���ݲ����ɹ�!',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
	              
                }else{
	                $.messager.popover({
		                msg: 'jsonData',
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});
                }
                $.messager.progress('close');
              }
            );
		 }})
	});
	
}  
   