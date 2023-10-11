$(document).ready(function() {

   initResGrid();      //����ͳ������ 
})


function Query()
{
	initResGrid()
}

//���ؽ������
function initResGrid(){
    
	var fromdate = $("#fromdate").datebox('getValue');
	var todate = $("#todate").datebox('getValue');
    
    // ����columns	
			var columns=[];
			runClassMethod("web.DHCCKBCalculateval","GetColumns",{'stDate':fromdate,'endDate':todate},function(jsonString){
				var jsonObject = jsonString;
				var ret = jsonObject.ret;
				var pid = jsonObject.pid;
				var length=jsonObject.columns.length;
				if(length>2)
				{
				  for(var i=4;i<length;i++){
					  jsonObject.columns[i].formatter=linkPrescdetails;
				  }
				}
				columns.push(jsonObject.columns);
		
		var option= {
			fitColumn :true,
			rownumbers : true,fixRowNumber:true,
			singleSelect : true,
			remoteSort:false,    
			pageSize : [30],
			pageList : [30,60,90],
			onClickRow: function (rowData) {
					        
 	 	},
		};

		var uniturl = $URL+"?ClassName=web.DHCCKBCalculateval&MethodName=QueryProCompData&pid="+pid+"&num="+ret+"&stDate="+fromdate+"&endDate="+todate
		new ListComponent('maingrid', columns, uniturl, option).Init();
	
	},'json','false')	

}

///����Ŀ��ϸ
function linkPrescdetails(value,rowData)
{
	if(value!=0){
		html = "<a href='#' onclick=\"LoadPrescDetailsWin('"+this.field+"','"+rowData.drugId+"','"+rowData.drugDesc+"','"+rowData.itmId+"')\">"+value+"</a>";				
	 return html;
	}
}

function LoadPrescDetailsWin(field,drugid,drug,itmId){	
	if($('#winlode').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'ҩƷ��ϸ�б�',
		collapsible:false,
		border:false,
		closed:"true",
		minimizable:false,
		width: window.screen.availWidth-50,
		height:window.screen.availHeight-100
	});
	var src= "dhcckb.prointegdetails.csp?drugId="+drugid+"&field="+ field +"&drug="+escape(drug)+"&itmId="+itmId;
	var iframe='<iframe scrolling="yes" width=100% height=98%  frameborder="0" src='+src+'></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
	
}