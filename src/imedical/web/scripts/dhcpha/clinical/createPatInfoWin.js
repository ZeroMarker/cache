
/// Creator:    bianshuai
/// CreateDate: 2014-06-17
/// Descript:   ���˾�����Ϣ����
var orditm=""
function createPatInfoWin(adm,patno)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	
	var offsetWidth=document.body.offsetWidth-100;
	var offsetHeight=document.body.offsetHeight-100;

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');
	//iframe ֱ�Ӽ���tab��div��
	//$('#tab').append('<div id="pal" title="������¼"><iframe scrolling="yes" width=100% height=100%  frameborder="0" src=""></iframe></div>');
	$('#ptab').append('<div id="pal" title="������¼"></div>');
	$('#ptab').append('<div id="ris" title="����¼"></div>');
	$('#ptab').append('<div id="lab" title="�����¼"></div>');
	$('#ptab').append('<div id="epl" title="ҩ�����"></div>');
	$('#ptab').append('<div id="ord" title="ҽ����"></div>');
	$('#ptab').append('<div id="oper" title="������Ϣ"></div>');
	$('#ptab').append('<div id="med" title="��ҩ����"></div>');
	$('#ptab').append('<div id="consultpat" title="�����б�"></div>');

	$('#win').window({
		title:'���˼�������Ϣ',
		collapsible:true,
		border:true,
		closed:"true",
		width:offsetWidth,   	/// 1200,
		height:offsetHeight,   	/// 550,
		minimizable:false,					/// ������С����ť
		maximizable:false,						/// ���(qunianpeng 2018/3/12)
		onClose:function(){
			$('#win').remove();  			/// ���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 
	$('#ptab').tabs({    
	    border:false,
	    fit:true, 
	    onSelect:function(title){
	        var tab = $('#ptab').tabs('getSelected'); 		 		/// ��ȡѡ������
	        var tbId = tab.attr("id");
	        var maintab="";
	        
	        switch(tbId){
	            case "pal":
					//maintab="dhcpha.comment.paallergy.csp";  		/// ������¼
					//maintab="dhcem.allergyenter.csp";               /// ������¼
					maintab="dhcdoc.allergyenter.csp";               /// ������¼
					break;
				case "ris":
					//maintab="dhcpha.comment.risquery.csp";   		/// ����¼
					//maintab="dhcem.inspectrs.csp";                  /// ����¼
					maintab="dhcapp.inspectrs.csp";                 /// ����¼
					break;
				case "lab":
					// maintab="dhcpha.comment.labquery.csp";		/// �����¼  ���ڽӿڱ���  //qunianpeng 2016-09-07
					//maintab="jquery.easyui.dhclaborder.csp"; 
					//maintab="dhcem.seepatlis.csp";                  /// �����¼
					maintab="dhcapp.seepatlis.csp";                  /// �����¼
					break;
				case "epl":
					//maintab="dhc.epr.public.episodebrowser.csp";  /// ҩ�����
					maintab="dhcpha.clinical.drugbrows.csp";
					break;
				case "ord":
					//maintab="dhcpha.comment.queryorditemds.csp";  /// ����ҽ��
					maintab="dhcpha.clinical.queryorditemds.csp";   /// ҽ���� qunianpeng 2018/3/13
					break;
				case "oper":
					maintab="dhcpha.clinical.operquery.csp";  		/// ������Ϣ
					break;
				case "med":
					maintab="dhcpha.clinical.medadvises.csp";  		/// ��ҩ����
					break;
				case "consultpat":
					maintab="dhcem.consultmain.csp";  		            /// �����б�
			}
			if(typeof AppType=="undefined"){AppType="";}

			//iframe ����
	        var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'?PatientID='+patno+'&EpisodeID='+adm+'&AppType='+AppType+'&ORditm='+orditm+'"></iframe>';
	        tab.html(iframe);
	        tab.panel('refresh');
			
			var ieset = navigator.userAgent;
			if (ieset.indexOf("MSIE 6.0") > -1){
				var currTab1 = $('#ptab').tabs('getSelected');
				setTimeout(refreshTab=function(refresh_tab){
					if (refresh_tab && refresh_tab.find('iframe').length > 0) {
						var _refresh_ifram = refresh_tab.find('iframe')[0];
						var refresh_url = _refresh_ifram.src;
						_refresh_ifram.contentWindow.location.href = refresh_url;
					}
				},0);
			}
	    }
	});
	$('#ptab').tabs('select','������¼'); //Ĭ��ѡ����
	$('#win').window('open');
}
function medadvises(ORditm){
	orditm=ORditm
	$('#ptab').tabs('select','��ҩ����');
	}
