/// 药学咨询主界面
$(function(){
	
	/**
	  *初始化选项卡
	  */
	$("#tabs").tabs({
		border:false,
	    fit:"true", 
	    onSelect:function(title){}
	});
	
	/**
	 * 给li标签绑定事件
	 */
	$('li').live('click',function(){
		var ListTitle=$('#'+this.id+" a").html();
		if (this.id == "D") {
			url = "dhcpha.clinical.pharconsult.csp";
			}
		if (this.id == "M") {
			url = "dhcpha.clinical.manaconsult.csp";
			}
		if (this.id == "P") {
			url = "dhcpha.clinical.patconsult.csp";
			}
		addAutoTab(ListTitle,url);
	})
})

/// 添加选项卡
function addAutoTab(title, url, closflag){
    if ($('#tabs').tabs('exists',title)){
        $('#tabs').tabs('select',title);
    }
    else{
        var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
        $('#tabs').tabs('add',{
            title:title,
            content:content,
            closable:closflag
        });
    }
}