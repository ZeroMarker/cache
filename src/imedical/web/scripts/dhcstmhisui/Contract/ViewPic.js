
function ViewPic(ConRowId){
	$UI.linkbutton('#DeletePicBT',{
		onClick:function(){
			DeletePic();
		}
	});	
	$UI.linkbutton('#SetMainPicBT',{
		onClick:function(){
			SetMainPic();
		}
	});	
	function DeletePic(){
		var RowId=GetIdSelected();
		if(isEmpty(RowId)){
			$UI.msg('alert','��ѡ��Ҫɾ����ͼƬ!')
			return;
		}
		var Param='';
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'DelContProductImageInfo',
			docRowId: RowId,
			Param:Param
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','ɾ���ɹ�!')
				$('#PicsList').empty();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
					MethodName: 'GetSynContProductImageInfo',
					RowId: ConRowId
				},function(jsonData){
					showPics(jsonData);
				});				
			}else{
				$UI.msg('error','ɾ��ʧ��!')
			}
			
		});			
		
	}
	function SetMainPic(){
		var RowId=GetIdSelected();
		if(isEmpty(RowId)){
			$UI.msg('alert','��ѡ��ͼƬ!')
			return;
		}
		var Param='';
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'SetContProductMaster',
			rowid: RowId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','�����ɹ�!')
				$('#PicsList').empty();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
					MethodName: 'GetSynContProductImageInfo',
					RowId: ConRowId
				},function(jsonData){
					showPics(jsonData);
				});				
			}else{
				$UI.msg('error','����ʧ��!')
			}
			
		});			
		
	}	
	function GetIdSelected(){
		var id=""
		$("#PicsList .selectedpic").each(function(){
			var i=$(this);
			var p=i.find("img");
			id=p.attr("id");
		})
		return id
	}
	var FtpParamObj = GetAppPropValue('DHCSTFTPFILEM')
	var tmpl = "<li class='imgbox'><img id=${RowId} data-original=http://"+FtpParamObj.FtpHttpSrc+"${PicSrc} src=http://"+FtpParamObj.FtpHttpSrc+"${PicSrc} alt=${ImgType}></li>" +
				"<div style='text-align:center'>${ImgType}</div>";
    function showPics( data ) {
      $.tmpl(tmpl, data ).appendTo( "#PicsList" );
      $("#PicsList").each(function(){
		var i=$(this);
		var p=i.find("li");
		p.click(function(){
			if(!!$(this).hasClass("selectedpic")){
				$(this).removeClass("selectedpic");
			}else{
				$(this).addClass("selectedpic").siblings("li").removeClass("selectedpic");
			}
		})
	  })
      $('#PicsList').viewer({zIndex:9999999999999});
    }
	$.cm({
		ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
		MethodName: 'GetSynContProductImageInfo',
		RowId: ConRowId
	},function(jsonData){
		showPics(jsonData);
	});	
	$HUI.dialog('#ViewPic',{
		onBeforeClose:function(){
			$('#PicsList').empty();
			$('#PicsList').viewer('destroy');
		}
	})
	$HUI.dialog('#ViewPic').open();
}