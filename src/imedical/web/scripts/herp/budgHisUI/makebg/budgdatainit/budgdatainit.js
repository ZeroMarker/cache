$(function(){//初始化
    Init();
}); 


function Init(){
	$.messager.popover({
		       msg:'将参考历史数据年度内的平均数作为预算编制年度的预算编制依据。',
		       type:'info',
		       timeout: 0,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"1000",
		              left:230,
		              top:170,
		              width:650
		              }});

//预算编制年度的下拉框
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
   
//历史数据年度起始年的下拉框
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
   
//历史数据年度结束年的下拉框
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
//预估数据月份开始月的下拉框
   var Date1Obj =  $HUI.combobox("#Date1Combo",{  
        valueField:'rowid',    
        textField:'name',
        data: [{
	                'rowid': 1,
                    'name': "1月"
                },{
	                'rowid': 2,
	                'name': "2月"
	            },{
		            'rowid': 3,
		            'name': "3月" 
		        },{
	                'rowid': 4,
                    'name': "4月"
                },{
	                'rowid': 5,
	                'name': "5月"
	            },{
		            'rowid': 6,
		            'name': "6月" 
		        },{
		            'rowid': 7,
		            'name': "7月" 
		        },{
	                'rowid': 8,
                    'name': "8月"
                },{
	                'rowid': 9,
	                'name': "9月"
	            },{
		            'rowid': 10,
		            'name': "10月" 
		        },{
		            'rowid': 11,
		            'name': "11月" 
		        },{
	                'rowid': 12,
                    'name': "12月"
                }]
     });
   //预估数据月份结束月的下拉框
   var Date2Obj =  $HUI.combobox("#Date2Combo",{  
        valueField:'rowid',    
        textField:'name',
        data: [{
	                'rowid': 1,
                    'name': "1月"
                },{
	                'rowid': 2,
	                'name': "2月"
	            },{
		            'rowid': 3,
		            'name': "3月" 
		        },{
	                'rowid': 4,
                    'name': "4月"
                },{
	                'rowid': 5,
	                'name': "5月"
	            },{
		            'rowid': 6,
		            'name': "6月" 
		        },{
		            'rowid': 7,
		            'name': "7月" 
		        },{
	                'rowid': 8,
                    'name': "8月"
                },{
	                'rowid': 9,
	                'name': "9月"
	            },{
		            'rowid': 10,
		            'name': "10月" 
		        },{
		            'rowid': 11,
		            'name': "11月" 
		        },{
	                'rowid': 12,
                    'name': "12月"
                }]
     });
   //按钮--数据初始化
   $("#dataInitButton").click(function(){
	   $.messager.confirm('确定','确认初始化吗？',function(t){
		 if(t){ 
        var cYear = $('#cyearCombo').combobox('getValue');
        if (cYear == "") {
	       $.messager.popover({
		       msg:'预算年度不能为空!',
		       type:'alert',
		       timeout: 2000,
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         $.messager.progress({
			 title: '提示',
			 msg: '正在初始化，请稍候……'
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
		                msg: '初始化成功！',
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
	
//按钮--参考数据计算
 $("#referDataButton").click(function(){
	 $.messager.confirm('确定','确认计算吗？',function(t){
		 if(t){ 
        var cYear = $('#cyearCombo').combobox('getValue');
        var bYear = $('#byearCombo').combobox('getValue');
        var eYear = $('#eyearCombo').combobox('getValue');
        
        if (cYear == "") {
	       $.messager.popover({
		       msg:'预算年度不能为空!',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (bYear == "") {
	       $.messager.popover({
		       msg:'历史开始年份不能为空',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (eYear == "") {
	       $.messager.popover({
		       msg:'历史结束年份不能为空',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (bYear > eYear) {
	       $.messager.popover({
		       msg:'历史开始年份不能大于历史结束年份',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (cYear <= eYear) {
	       $.messager.popover({
		       msg:'预算年份应大于历史结束年份',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         
       $.messager.progress({
			title: '参考数据计算',
			msg: '数据正在处理中...请稍后'
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
		                msg: '预算已下达,禁止操作!',
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		                       top:1}});     
                }else if(jsonData == 0){
	                $.messager.popover({
		                msg: '数据操作成功！',
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
	///按钮--预估数据计算
   $("#splitBtn").click(function(){
	   $.messager.confirm('确定','确认计算吗？',function(t){
		 if(t){ 
        var cYear = $('#cyearCombo').combobox('getValue');
        var bYear = $('#byearCombo').combobox('getValue');
        var eYear = $('#eyearCombo').combobox('getValue');
        if (cYear == "") {
	       $.messager.popover({
		       msg:'预算年度不能为空!',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
          if (bYear == "") {
	       $.messager.popover({
		       msg:'历史开始年份不能为空',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         if (eYear == "") {
	       $.messager.popover({
		       msg:'历史结束年份不能为空',
		       timeout: 2000,type:'alert',
		       showType: 'show',
		       style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2,
		              top:1}});
           return;
         };
         
         $.messager.progress({
			 title: '提示',
			 msg: '数据正在处理中...请稍后'
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
		                msg: '数据操作成功!',
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
   