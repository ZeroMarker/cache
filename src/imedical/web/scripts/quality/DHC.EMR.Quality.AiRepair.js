$(function(){
	initcombox();
	InitDataList();
	Summary("view1");
	$('#AdmType').combobox('setValue',"A")
	$("#StartText").html(emrTrans("入院开始时间"));
	$("#EndText").html(emrTrans("入院结束时间"));
	if(HISUIStyleCode == "lite"){
	    $(".b_color").css({'background-color':'#f5f5f5'});
	}
});
var eprPatient= new Object();
eprPatient.CTLocID = "";
eprPatient.StartDate = "";
eprPatient.EndDate = "";
eprPatient.Type = "";
eprPatient.AdmType = "";
eprPatient.MedicareNo=""
function initcombox()
{
$('#ctLocID').combobox
	({
		valueField:'ID',  
	    textField:'Name',
		url:'../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&HospitalID='+HospitalID, 
		mode:'remote',
		onChange: function (n,o) {
			$('#ctLocID').combobox('setValue',n);
		    var newText = $('#ctLocID').combobox('getText');
			$('#ctLocID').combobox('reload','../web.eprajax.usercopypastepower.cls?Action=GetCTLocID&Type=E&Filter='+encodeURI(newText.toUpperCase())); //
		},
		onSelect: function(record){
			
	    },
	    onLoadSuccess:function(){
	    }
    });
    var AdmTypebox = $HUI.combobox("#AdmType",{
			valueField:'id',
			textField:'text',
			//multiple:true,
			//rowStyle:'checkbox', 
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			data:[
				{id:'A',text:emrTrans('在院')},{id:'D',text:emrTrans('出院')}
			],
			onSelect: function(record){
				if (record.id=="A")
				{
				$("#StartText").html("入院开始时间");
				$("#EndText").html("入院结束时间");

				}else if (record.id=="D")
				{
				$("#StartText").html("出院开始时间");
				$("#EndText").html("出院结束时间");	
				
				}
		    } 
	});
   var Typebox = $HUI.combobox("#Type",{
			valueField:'id',
			textField:'text',
			multiple:true,
			rowStyle:'checkbox', 
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:true,
			data:[
				{id:'R',text:emrTrans('已修复')},{id:'E',text:emrTrans('未修复')}
			]
	});	
}

function InitDataList()
{
	$('#patientListTable').datagrid({ 
			pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
			method: 'post',
            loadMsg: '加载中......',
			autoRowHeight: true,
			url:'../EPRservice.Quality.Ajax.AiRepair.cls',
			queryParams: {
				CTLocID: eprPatient.CTLocID,
				StartDate:eprPatient.StartDate,
				EndDate: eprPatient.EndDate,
				Type:eprPatient.Type,
				AdmType:eprPatient.AdmType,
				MedicareNo:eprPatient.MedicareNo
            },
			fit:true,
			columns:[[
				{field: 'ckb', checkbox: true },
				{field:'Name',title:'姓名',width:100,align:'left',
					styler: function(value,row,index){
						if(HISUIStyleCode == "lite"){
							return 'border-left:1px solid #cccccc;border-right:1px solid #cccccc';
							}							
					}
				},
				{field:'LocDesc',title:'科室',width:100,align:'left'},
				{field:'MRNo',title:'病案号',width:100,align:'left'},				
				{field:'DoctorDesc',title:'主治医生',width:100,align:'left'},
				{field:'Title',title:'质控条目',width:150,align:'left'},
				{field:'Trigger',title:'触发日期',width:150,align:'left'},
				{field:'StatusDesc',title:'状态',width:100,align:'left',
					formatter: function(value,row,index){
						return emrTrans(value)
					}
				},
				{field:'Repair',title:'修复日期',width:150,align:'left'},
			]],
			onLoadSuccess: function(data){   
			var mark=1;     
			for(var i=1; i <data.rows.length; i++)  { 
			if (data.rows[i]['Name'] == data.rows[i-1]['Name'])
				{
	　　　　　　　　mark += 1;                                            
	　　　　　　　　$(this).datagrid('mergeCells',{
	　　　　　　　　　　index: i+1-mark,                 
	　　　　　　　　　　field: 'Name',                 
	　　　　　　　　　　rowspan:mark  
					})
	　　　　　　}else{
	　　　　　　　　mark=1;                               
	　　　　　　}
		　　　　}
		　　},
		 	onDblClickRow: function(rowIndex, rowData) {
				var episodeID = rowData.PAADMRowID
				//var url = "dhc.emr.quality.checkrule.csp?EpisodeID="+episodeID+ '&action=A';
				var url = "emr.browse.csp?&EpisodeID="+episodeID+"&Action=quality";
				if ('undefined' != typeof websys_getMWToken)
				{
					url += "&MWToken="+websys_getMWToken();
				}
				window.open (url,'newwindow','top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=yes,location=no, status=no,channelmode=yes ') 
				
			},
			loadFilter:function(data)
			{
				if(typeof data.length == 'number' && typeof data.splice == 'function'){
					data={total: data.length,rows: data}
				}
				var dg=$(this);
				var opts=dg.datagrid('options');
				var pager=dg.datagrid('getPager');
				pager.pagination({
					onSelectPage:function(pageNum, pageSize){
						opts.pageNumber=pageNum;
						opts.pageSize=pageSize;
						pager.pagination('refresh',{pageNumber:pageNum,pageSize:pageSize});
						dg.datagrid('loadData',data);
					}
				});
				if(!data.originalRows){
					data.originalRows = (data.rows);
				}
				var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
				var end = start + parseInt(opts.pageSize);
				data.rows = (data.originalRows.slice(start, end));
				return data;
			}
			}); 	
}

function doSearch()
{
	var queryParams = $('#patientListTable').datagrid('options').queryParams;
     queryParams.StartDate = $("#inputCreateDateStart").datetimebox('getText');
     queryParams.EndDate =$("#inputCreateDateEnd").datetimebox('getText');
	 queryParams.CTLocID =$("#ctLocID").combobox('getValue')
	 queryParams.Type=""+$("#Type").combobox('getValues')+""
	 queryParams.AdmType =$("#AdmType").combobox('getValue')
	 queryParams.MedicareNo =$("#MedicareNo").val()
	 
	 if(queryParams.AdmType==""){ $.messager.alert("提示","请选择阶段！"); 
	 }else if((queryParams.AdmType=="D")&&(queryParams.MedicareNo=="")&&((queryParams.StartDate=="")||(queryParams.EndDate==""))){
			 $.messager.alert("提示","出院患者查询请选择出院时间段！"); 
	 }
     $('#patientListTable').datagrid('options').queryParams = queryParams;
     $('#patientListTable').datagrid('reload');			   	
}

function exportExcel(){
    var options = $('#patientListTable').datagrid('getPager').data("pagination").options; 
    var curr = options.pageNumber; 
    var total = options.total;
    var pager = $('#patientListTable').datagrid('getPager');
    var rows = []
    for (i=1;i<=((total/options.pageSize)+1);i++)
    {
	     pager.pagination('select',i);
         pager.pagination('refresh');
         var currows =  $('#patientListTable').datagrid('getRows');
         console.log(currows)
         if (currows.length==0)
         {
	         continue;
	     }
         for (var j in currows)
         {
	         rows.push(currows[j]);
	     }
	}
	 pager.pagination('select',curr);
     pager.pagination('refresh');
	$('#patientListTable').datagrid('toExcel',{
		filename:'内涵质控触犯修正明细.xls',
		rows:rows
		});
	}
	
function Summary(ElementID)
{
	
	jQuery.ajax({
				type: "get",
				dataType: "json",
				url: "../EPRservice.Quality.Ajax.AiRepair.cls",
				async: false,
				data: {
					"Action":"View",		
				},
				success: function(d) {
					var LocID=[];
					var LocDesc=[];
					var Err=[];
					var Rep=[];
					for (var i = d.length-1; i >=0; i--) {
						LocID.push(d[i].LocID)
						LocDesc.push(emrTrans(d[i].LocDesc))
						Err.push(d[i].Err)
						Rep.push(d[i].Rep) 
					} 
				var showLine = echarts.init(document.getElementById(ElementID));
				showLine.setOption(yBarDouble(emrTrans('内涵质控触犯情况科室排名'),[emrTrans('触犯数量'),emrTrans('修复数量')],LocDesc,Err,Rep));
				}
	})
}

function yBarDouble(Title,Legend,yAxisData,AData,BData)
{
	yBarDoubleoption = {
    title: {
        text: Title,
        subtext: '',
        left:6,
        top:0
        
    },
    tooltip: {
        trigger: 'axis',
        axisPointer: {
            type: 'shadow'
        }
    },
    legend: {
        data: Legend,
        right:"3%"
    },
    grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
    },
    xAxis: {
        type: 'value',
        boundaryGap: [0, 0.01]
    },
    yAxis: {
        type: 'category',
        data: yAxisData,
		axisLabel:{
		        	interval:0
	        }
    },
    series: [
        {
            name: Legend[0],
            type: 'bar',
            data: AData
        },
        {
            name: Legend[1],
            type: 'bar',
            data: BData
        }
    ]
};	
	return yBarDoubleoption
}