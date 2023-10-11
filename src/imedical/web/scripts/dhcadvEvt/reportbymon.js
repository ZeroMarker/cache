 // Creator: yangyongtao
// CreateDate: 2018-11-26
// Descript: �����¼����°�����ͳ��
var url = "dhcadv.repaction.csp";
var MonQuartCompare=""
var QuyTypeArr= [{"value":"MONTH","text":$g('����ͳ��')}, {"value":"QUART","text":$g('������ͳ��')}];
$(function(){
	InitPageComponent(); 	  /// ��ʼ������ؼ�����
	InitPageButton();         /// ���水ť����
	InitPageDataGrid();		  /// ��ʼ��ҳ��datagrid
})
// ��ʼ������ؼ�����
function InitPageComponent(){
	// ��ȡ����ַ���
	InitYearStr(); 
	// ͳ������
	$('#qrytype').combobox({
		value:"MONTH",
		text:$g("����ͳ��"),
		editable:false,
		data:QuyTypeArr
	});
	// ����
	$('#dept').combobox({ //  yangyongtao   2017-11-17
		mode:'remote',  //���������������
		onShowPanel:function(){ 
			$('#dept').combobox('reload',url+'?action=GetAllLocNewVersion&hospId='+LgHospID+'')
		}
	});	
	// ��������
	$('#typeevent').combobox({
		//panelHeight:"auto",  //���������߶��Զ�����
		url:url+'?action=SelEventbyNew&param='+LgParam
	});
	$("#qrytype").combobox("setValue", "MONTH"); 
}

// ��ʼ�����水ť����
function InitPageButton()
{
	// ��ѯ
	$("#FindByMon").click(function(){
		query();
	})
	// ����
    $("#ExportByMon").click(function(){
		Export();  
   })
}
// ��ʼ������ͼ������
function InitPageDataGrid()
{
	//�����¼����°�����ͳ��
	MonQuartCompare=echarts.init(document.getElementById('MonQuartCompare'));
	query();
}
// �����ѯ
function query(){
	
	var CurrYear=$("#yearStr").combobox('getValue'); //��ǰ��
	var yearStr=$("#yearStr").val()//combobox('getValue');
	if(yearStr==""){
		yearStr=CurrYear
    }
	
	var reptype=$('#typeevent').combobox('getValue');  //�¼�����
	var locStr=$('#dept').combobox('getValue');        //����
	var qrytype=$("#qrytype").combobox('getValue'); //ͳ������
	var params=LgParam; //hxy 2020-02-26
	//var data=serverCall("web.DHCADVREPBYMON","GetAdvStat",{"yearstr":year,"reptype":reptype,"replocstr":locStr,"qrytype":qrytype});
    runClassMethod("web.DHCADVREPBYMON","GetAdvStat",{yearstr:yearStr,reptype:reptype,replocstr:locStr,qrytype:qrytype,params:params},function(data){
    var TempArr=[],YearArr=[],DataArr=[]
     var yeatArr=yearStr.split(",");
		for(var i =0;i<yeatArr.length;i++){ 
           DataArr[i]=(data[yeatArr[i]]).split(",");  //�ַ���ת����
			var obj={};
			obj.name=yeatArr[i];
			obj.type='line';
			obj.data= DataArr[i].slice(0,12);  // 2021-02-23 cy  slice(start,end) ����һ���µ����飬������ start �� end ����������Ԫ�أ��������е�Ԫ�ء� 
			TempArr.push(obj);
			YearArr.push(yeatArr[i]);
		}
		if(qrytype=="MONTH"){
		  InitMonthCompare(YearArr,TempArr); // ����ͳ��
		  InitMonCompareTable(yearStr,data);

		}
		if(qrytype=="QUART"){
		   InitQuartCompare(YearArr,TempArr);  //������ͳ��
		   InitQuartCompareTable(yearStr,data);
		}
		
		
	}) 
   
}

 //����ͳ��	
function InitMonthCompare(YearArr,TempArr){

	option = {
		//color: ['#003366', '#006699', '#4cabce', '#e5323e'],
    	title : {
        	text:$g('���·�ͳ��'),
        	x:'center'
       
    	},
	    tooltip: {
	        trigger: 'axis'
	    },
	    
	   legend: {
              data:YearArr, //['2017','2018']
              x:150,
              y:30
       },
	    toolbox: {
	        show: true,
	        feature: {
	            /* dataZoom: {
	                yAxisIndex: 'none'
	            },
	            dataView: {readOnly: false}, */
	            magicType: {type: ['line', 'bar']},
	            restore: {},
	            saveAsImage: {}
	        }
	    },
    	calculable : true,
    	xAxis : [
        	{
	        	name:$g("�·�"),
            	type : 'category',
            	data : [$g("1��"),$g("2��"),$g("3��"),$g("4��"),$g("5��"),$g("6��"),$g("7��"),$g("8��"),$g("9��"),$g("10��"),$g("11��"),$g("12��")]  //,"�ϼ�"
        	}
    	],
    	yAxis : [
        {
            type : 'value',
            name:$g("��������"),
            nameLocation:'middle',
            nameTextStyle:{
	            padding: [10,10,20,10]
	        }
        }
    	],
    	series :TempArr
   	 }
   	 MonQuartCompare.clear();
     MonQuartCompare.setOption(option);
	
}


 //����ͳ��	
function InitQuartCompare(YearArr,TempArr){
	option = {
		//color: ['#003366', '#006699', '#4cabce', '#e5323e'],
    	title : {
        	text:$g('������ͳ��'),
        	x:'center'
    	},
    	
       legend: {
              data:YearArr, //['2017','2018']
              x:150,
              y:30
       },
	    tooltip: {
	        trigger: 'axis'
	    },
	    toolbox: {
	        show: true,
	        feature: {
	            /* dataZoom: {
	                yAxisIndex: 'none'
	            },
	            dataView: {readOnly: false}, */
	            magicType: {type: ['line', 'bar']},
	            restore: {},
	            saveAsImage: {}
	        }
	    },
    	calculable : true,
    	xAxis : [
        	{
	        	name:$g("����"),
            	type : 'category',
            	data : [$g("��1����"),$g("��2����"),$g("��3����"),$g("��4����")]  //,"�ϼ�"
        	}
    	],
    	yAxis : [
        {
            type : 'value',
            name:$g("��������"),
            nameLocation:'middle',
            nameTextStyle:{
	            padding: [10,10,20,10]
	        }
        }
    	],
    	series :TempArr
   	 }
   	 MonQuartCompare.clear();
     MonQuartCompare.setOption(option);
	
}


//�����б�ͳ��
function InitMonCompareTable(yearStr,data){
			var htmlStr="<table class='easyui-datagrid' style='width:100%'>";

			htmlStr=htmlStr+"<tr>"
			htmlStr=htmlStr+"<th style='background-color:#F0EDED'>"+$g("���")+"</th>"
			for(j=1;j<=13;j++){
			    if(j==13){
				    htmlStr=htmlStr+"<th style='background-color:#F0EDED;height:40px;'>"+$g("�ϼ�")+"</th>"	
				}else{
				     htmlStr=htmlStr+"<th style='background-color:#F0EDED;height:40px;'>"+$g(+[j]+"��")+"</th>"
				}	

			}	
			htmlStr=htmlStr+"</tr>"
			
		   var yeatArr=yearStr.split(",");
		   for(var i =0;i<yeatArr.length;i++){
			   htmlStr=htmlStr+"<tr>"
			   htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+yeatArr[i]+"</td>"
               var DataArr=(data[yeatArr[i]]).split(",");  //�ַ���ת����
               for(var k =1;k<=13;k++){
			      htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+DataArr[k-1]+"</td>"			   
			   }
			}
			
			htmlStr=htmlStr+"</tr>"
			htmlStr=htmlStr+"</table>";
			$("#MonCompareTable").html(htmlStr)
	
}


//�������б�ͳ��
function InitQuartCompareTable(yearStr,data){
			var htmlStr="<table class='easyui-datagrid' style='width:100%'>";

			htmlStr=htmlStr+"<tr>"
			htmlStr=htmlStr+"<th style='background-color:#F0EDED'>"+$g("���")+"</th>"
			for(j=1;j<=5;j++){
				if(j==5){
				    htmlStr=htmlStr+"<th style='background-color:#F0EDED;height:40px;'>"+$g("�ϼ�")+"</th>"	
			    }else{
				    htmlStr=htmlStr+"<th style='background-color:#F0EDED;height:40px;'>"+$g("��"+[j]+"����")+"</th>"	
				}
				
			}	
			htmlStr=htmlStr+"</tr>"
			
		   var yeatArr=yearStr.split(",");
		   for(var i =0;i<yeatArr.length;i++){
			   htmlStr=htmlStr+"<tr>"
			   htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+yeatArr[i]+"</td>"
               var DataArr=(data[yeatArr[i]]).split(",");  //�ַ���ת����
               for(var k =1;k<=5;k++){
			      htmlStr=htmlStr+"<td style='background-color:#F0EDED;text-align:center;height:40px;'>"+DataArr[k-1]+"</td>"			   
			   }
			}
			
			htmlStr=htmlStr+"</tr>"
			htmlStr=htmlStr+"</table>";
			$("#MonCompareTable").html(htmlStr)
	
}

//hxy ����ҳ
function Gologin(){
	location.href='dhcadv.homepage.csp';
}


//��ȡ����ַ���
function  InitYearStr(){
	
	str=serverCall("web.DHCADVREPBYMON","GetCurrYear");
	strArr=str.split("-")
    var yearArr = [];//�����������
    for(year= parseInt(strArr[0])-10;year<=parseInt(strArr[0]);year++)
	{
		 yearArr.push({"value":year,text:year});
	}
	
	var value = "";
	//����������ѡ��
	$("#yearStr").combobox({
		data:yearArr,
        panelHeight:200,//����Ϊ�̶��߶ȣ�combobox������ֱ������
        valueField:'value',
        textField:'text',
        multiple:true,
        formatter: function (row) { //formatter��������ʵ������ÿ������ѡ��ǰ������checkbox��ķ���
            var opts = $(this).combobox('options');
            return '<input type="checkbox" class="combobox-checkbox">' + row[opts.textField]
        },
        onLoadSuccess: function () {  //���������ݼ��سɹ�����
            var opts = $(this).combobox('options');
            var target = this;
            var values = $(target).combobox('getValues');//��ȡѡ�е�ֵ��values
            $("#yearStr").combobox("setValue", strArr[0]); 
            $.map(values, function (value) {
                var el = opts.finder.getEl(target, value);
                el.find('input.combobox-checkbox')._propAttr('checked', true); 
            })
        },
        onSelect: function (row) { //ѡ��һ��ѡ��ʱ����
            var opts = $(this).combobox('options');
            //��ȡѡ�е�ֵ��values
            $("#yearStr").val($(this).combobox('getValues'));
           
		   //����ѡ��ֵ����Ӧ�ĸ�ѡ��Ϊѡ��״̬
            var el = opts.finder.getEl(this, row[opts.valueField]);
            el.find('input.combobox-checkbox')._propAttr('checked', true);
        },
        onUnselect: function (row) {//��ѡ��һ��ѡ��ʱ����
            var opts = $(this).combobox('options');
            //��ȡѡ�е�ֵ��values
            $("#yearStr").val($(this).combobox('getValues'));
          
            var el = opts.finder.getEl(this, row[opts.valueField]);
            el.find('input.combobox-checkbox')._propAttr('checked', false);
        }
    });


}

//�����б�����
function Export(){
	
	var CurrYear=$("#yearStr").combobox('getValue'); //��ǰ��
	var yearStr=$("#yearStr").val()//combobox('getValue');
	if(yearStr==""){
		yearStr=CurrYear
    }
	
	var reptype=$('#typeevent').combobox('getValue');  //�¼�����
	var locStr=$('#dept').combobox('getValue');        //����
	var qrytype=$("#qrytype").combobox('getValue'); //ͳ������
	var params=LgParam; //hxy 2020-02-26
	//var data=serverCall("web.DHCADVREPBYMON","GetAdvStat",{"yearstr":year,"reptype":reptype,"replocstr":locStr,"qrytype":qrytype});
    runClassMethod("web.DHCADVREPBYMON","GetAdvStat",{yearstr:yearStr,reptype:reptype,replocstr:locStr,qrytype:qrytype,params:params},function(data){

		if(qrytype=="MONTH"){
		  InitMonExportTable(yearStr,data)

		}
		if(qrytype=="QUART"){
		   InitQuartExportTable(yearStr,data)
		}
		
		
	}) 
		
}

//���µ�������
function InitMonExportTable(yearStr,data){
        var htmlStr="<table id='tableid'>";
        var htmlStr="";
		htmlStr=htmlStr+"<tr >"
		htmlStr=htmlStr+"<td colspan=14 style='font-size:20px;font-weight:bold;text-align:center;'>"
		htmlStr=htmlStr+$g("����ͳ��")
		htmlStr=htmlStr+"</td>"
		htmlStr=htmlStr+"</tr>"
		htmlStr=htmlStr+"<th>"+$g("���")+"</th>"
		for(j=1;j<=13;j++){
		    if(j==13){
			      htmlStr=htmlStr+"<th >"+$g("�ϼ�")+"</th>"	
			}else{
			     htmlStr=htmlStr+"<th>"+$g(+[j]+"��")+"</th>"
			}	
		}	
		htmlStr=htmlStr+"</tr>"
		
	   var yeatArr=yearStr.split(",");
	   for(var i =0;i<yeatArr.length;i++){
		   htmlStr=htmlStr+"<tr>"
		   htmlStr=htmlStr+"<td>"+yeatArr[i]+"</td>"
           var DataArr=(data[yeatArr[i]]).split(",");  //�ַ���ת����
           for(var k =1;k<=13;k++){
		      htmlStr=htmlStr+"<td >"+DataArr[k-1]+"</td>"			   
		   }
		}
		
		htmlStr=htmlStr+"</tr>"
		htmlStr=htmlStr+"</table>";
        ExportTableToExcel($g("����ͳ��"),htmlStr)
}


//�����ȵ�������
function InitQuartExportTable(yearStr,data){
        var htmlStr="";
		htmlStr=htmlStr+"<tr >"
		htmlStr=htmlStr+"<td colspan=6 style='font-size:20px;font-weight:bold;text-align:center;'>"
		htmlStr=htmlStr+$g("������ͳ��")
		htmlStr=htmlStr+"</td>"
		htmlStr=htmlStr+"</tr>"
		htmlStr=htmlStr+"<th>"+$g("���")+"</th>"
		for(j=1;j<=5;j++){
			if(j==5){
			    htmlStr=htmlStr+"<th>"+$g("�ϼ�")+"</th>"	
		    }else{
			    htmlStr=htmlStr+"<th>"+$g("��"+[j]+"����")+"</th>"	
			}
			
		}	
		htmlStr=htmlStr+"</tr>"
		
	   var yeatArr=yearStr.split(",");
	   for(var i =0;i<yeatArr.length;i++){
		   htmlStr=htmlStr+"<tr>"
		   htmlStr=htmlStr+"<td>"+yeatArr[i]+"</td>"
           var DataArr=(data[yeatArr[i]]).split(",");  //�ַ���ת����
           for(var k =1;k<=5;k++){
		      htmlStr=htmlStr+"<td>"+DataArr[k-1]+"</td>"			   
		   }
		}
		
		htmlStr=htmlStr+"</tr>"
        ExportTableToExcel($g("������ͳ��"),htmlStr)
}


