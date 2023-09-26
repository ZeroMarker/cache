
function ViewPic(){
	var Inci=$('#Inci').val();
	if(isEmpty(Inci)){
		$UI.msg('alert','ÇëÑ¡ÔñÒªä¯ÀÀµÄÍ¼Æ¬µÄ¿â´æÏî!')
		return
	}
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
			$UI.msg('alert','ÇëÑ¡ÔñÒªÉ¾³ýµÄÍ¼Æ¬!')
			return;
		}
		var Param='';
		$.cm({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'DelProductImageInfo',
			docRowId: RowId,
			Param:Param
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','É¾³ý³É¹¦!')
				$('#PicsList').empty();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
					MethodName: 'GetProductImageInfo',
					Inci: Inci
				},function(jsonData){
					showPics(jsonData);
				});				
			}else if(jsonData.success!=0){
				$UI.msg('error','É¾³ýÊ§°Ü!')
			}
		});			
		
	}
	function SetMainPic(){
		var RowId=GetIdSelected();
		if(isEmpty(RowId)){
			$UI.msg('alert','ÇëÑ¡ÔñÍ¼Æ¬!')
			return;
		}
		var Param='';
		$.cm({
			ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
			MethodName: 'SetProductMaster',
			rowid: RowId
		},function(jsonData){
			if(jsonData.success==0){
				$UI.msg('success','²Ù×÷³É¹¦!')
				$('#PicsList').empty();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
					MethodName: 'GetProductImageInfo',
					Inci: Inci
				},function(jsonData){
					showPics(jsonData);
				});				
			}else{
				$UI.msg('error','²Ù×÷Ê§°Ü!')
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
		ClassName: 'web.DHCSTMHUI.DrugInfoMaintain',
		MethodName: 'GetProductImageInfo',
		Inci: Inci
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