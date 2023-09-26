var columns=getCurColumnsInfo('PLAT.G.CT.Notice','','','');  
$(document).ready(function () {
	initDocument();
});
function initDocument()
{
	defindTitleStyle(); 
	initInvoiceInfo("tSystemList");	
	initInvoiceInfo("tIndustryStandSpecList");	
	initInvoiceInfo("tInAnnouncementList");	
	initInvoiceInfo("tLawsRegulationsList");	
	initKeyWords();
	initCheckbox();
	//$('.div-all').empty()
	$HUI.radio("#Month").setValue(true)
	
}

function SearchHander(value,name)
{
	setElement("SearchAll",value);
	initInvoiceInfo("tSystemList");
	
}

///add by lmm 2020-04-20 ����ҵ����������ģ��
function initKeyWords()
{
	$("#Invoicekw").keywords({     
	singleSelect:true,     
	labelCls:'',     
	items:[{text:'ȫ    ��',id:'Allkw'},
	{text:'��    ��',id:'Systemkw'},         
	{text:'��ҵ�淶',id:'IndustryStandSpeckw'},         
	{text:'ҽԺ����',id:'InAnnouncementkw'},         
	{text:'���ɷ���',id:'LawsRegulationskw'},
	{text:'��������ģ��',id:'BaseDatakw'},
	{text:'ҵ������ģ��',id:'BussDatakw'},
	
	],     
	onClick:function(jsonData){
	RefreshList(jsonData)
	
	}    
	});	
	
}
//modify by lmm 2020-04-20 ����ģ��
function RefreshList(jsonData)
{	
	switch(jsonData.id){
		case 'Allkw':
			var title="����"
			var InvoiceCatDR=""
			break;
		case 'Systemkw':
			var title="�ƶ�"
			var InvoiceCatDR=1
			break;
		case 'IndustryStandSpeckw':
			var title="��ҵ�淶"
			var InvoiceCatDR=2
			break;
		case 'InAnnouncementkw':				
			var title="ҽԺ����"
			var InvoiceCatDR=3
			break;
		case 'LawsRegulationskw':				
			var title="���ɷ���"
			var InvoiceCatDR=4
			break;
		case 'BaseDatakw':				
			var title="��������ģ��"
			var InvoiceCatDR=5
			break;
		case 'BussDatakw':				
			var title="ҵ������ģ��"
			var InvoiceCatDR=6
			break;
		default:
			break;
	}
	setElement("InvoiceCatDR",InvoiceCatDR);
	$('#west').panel('setTitle',title);
	initInvoiceInfo("tSystemList");
		//window.setTimeout(function(){window.location.href="dhceq.plat.mainnotice.csp?&title="+title+"&InvoiceCatDR="+InvoiceCatDR},50); 
		
}
function initCheckbox()
{
	$HUI.radio("[name='order']",{
         onChecked:function(e,value){
            var checkedRadioJObj = $("input[name='order']:checked");             
            if (checkedRadioJObj.val()=="Month")
            {
				var DateRange="Month"
				var title="����"
				var InvoiceCatDR=""
	         }
            else if (checkedRadioJObj.val()=="All")
            {
				var DateRange=""
				var title="����"
				var InvoiceCatDR=""
	         }
			setElement("DateRange",DateRange);
			$('#west').panel('setTitle',title);
			initInvoiceInfo("tSystemList");
	         
				//window.setTimeout(function(){window.location.href="dhceq.plat.mainnotice.csp?&title="+title+"&InvoiceCatDR="+InvoiceCatDR+"&DateRange="+DateRange},50); 
         }
	})
	

	
}
function initInvoiceInfo(tableName)
{
	
	$.cm({
		ClassName:"web.DHCEQ.Plat.LIBPNotice",
		QueryName:"GetNotice",
	        NoticeCatDR:getElementValue("InvoiceCatDR"),
	        Title:'',
	        Content:'',
	        Status:'2',
	        StartDate:'',
	        EndDate:'',
	        DateRange:getElementValue("DateRange"),
	        SearchAll:getElementValue("SearchAll"),
	        EffectiveFlag:"Y",
	},
	function(jsonData){
		createInvoice(jsonData,tableName);
	});	
}

function createInvoice(jsonData,tableName)
{
	$("#"+tableName).empty(); //ÿ�μ���֮ǰ�Ƴ���ʽ
	//��ʱ�䵹��,�����ֵ����
	for (var i=jsonData.rows.length-1;i>=0;i--)
	{
		var RowID=jsonData.rows[i].TRowID; 
		var Title=jsonData.rows[i].TTitle;	
		var Abstract=jsonData.rows[i].TAbstract;
		var SubTitle=jsonData.rows[i].TSubTitle;
		var ContentType=jsonData.rows[i].TContentType;
		var OperateLogDate=jsonData.rows[i].TOperateLogDate;
		var OperateLogTime=jsonData.rows[i].TOperateLogTime;
		var OperateLogUser=jsonData.rows[i].TOperateLogUser;
		
		var Url='href="#" onclick="javascript:InvoiceDetail('+RowID+','+ContentType+')"';
		opt={
			id:RowID,
			title:Title,
			sbstract:Abstract,
			url:Url,
			subTitle:SubTitle,
			operateLogDate:OperateLogDate,
			operateLogTime:OperateLogTime,
			operateLogUser:OperateLogUser,
		}
		createInvoiceList(opt,tableName);
		
		
	}
	
}
function createInvoiceList(options,tableName)
{
	var defaults = {
		id:'',
		title:'',
		sbstract:'',
		subTitle:'',
		operateLogDate:'',
		operateLogTime:'',
		operateLogUser:'',
	};
    var options = jQuery.extend(defaults, options || {});
    
	if (options.id=="") return;	
	var html=""
	html='<div class="news-view" style="">'+
	'<div class="news-header">'+
	''+
	'<a '+options.url+' title='+options.subTitle+'>'+options.title+'</a>'+
	''+
	'</div>'+
	'<div class="news-main">'+
	'<p><span>'+options.sbstract+'</span></p>'+
	'</div>'+
	'<div class="news-footer"><p>'+
	'<span class="operater">'+
	options.operateLogUser+
	'<i> �� </i>'+
	'</span>'+
	'<span class="date">'+options.operateLogDate+" "+options.operateLogTime+
	'</span></p></div></div>'
	
	
	$("#"+tableName).append(html);
	
}


function InvoiceDetail(RowID,ContentType)
{
	
	VisitorLog(RowID);
	if (ContentType==0)
	{
		var url="dhceq.plat.pnoticedetail.csp?&RowID="+RowID
		var title="������Ϣ"
		var width=""
		var height=""
		var icon="icon-w-edit"
		var showtype=""
		showWindow(url,title,width,height,icon,showtype,"","","middle"); //modify by lmm 2020-06-05 UI
	}
	else if(ContentType==1)
	{
		var url='dhceq.plat.picturemenu.csp?&CurrentSourceType=67&CurrentSourceID='+RowID+'&Status=2&ReadOnly=1';
		showWindow(url,"������Ϣ","","","icon-w-paper","modal","","","middle"); //modify by lmm 2020-06-05 UI
	} 
	else if(ContentType==2)
	{
		//Modefied by zc0060 20200329 �ļ��ϴ����� 
		//var str='dhceq.process.appendfile.csp?&CurrentSourceType=67&CurrentSourceID='+RowID+'&Status=2&ReadOnly=1';
		var str='dhceq.plat.appendfile.csp?&CurrentSourceType=67&CurrentSourceID='+RowID+'&Status=2&ReadOnly=1';
		//Modefied by zc0060 20200329 �ļ��ϴ�����  end
		showWindow(str,"������Ϣ","","","icon-w-paper","modal","","","middle"); //modify by lmm 2020-06-05 UI
	} 
	
}

function VisitorLog(RowID)
{
	var combindata=""
	var combindata=combindata+"^67"
	var combindata=combindata+"^"+RowID
	var combindata=combindata+"^"
	var combindata=combindata+"^"
	var combindata=combindata+"^"
	
	var Rtn = tkMakeServerCall("web.DHCEQ.Plat.BUSPVisitorLog", "SaveData",combindata);
	
	
	return
}

