Ext.QuickTips.init();

  function getCenterListTbar()
  {
	var tbar = new Ext.Toolbar({ disabledClass:'x-item-disabled', border: false, items:['->','-',
		{ id: 'btnPreview', text: '预览', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/preview.gif', pressed: false,handler:preview}, '-', 
		{ id: 'btnPrint',text: '打印', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/print.gif', pressed: false, handler:print}
	]});
    return tbar
  }
	var frmMainContent = new Ext.Viewport(
    {
        id: 'centerTabViewPort',
        shim: false,
        animCollapse: false,
        constrainHeader: true,
        margins:'0 0 0 0', 
        layout: 'border',
        items: [{
            border: false,
            region: 'center', 
            layout: 'border',
            items: [
	
			{
                border: false,
                region: 'north',
                height: 27, 
                layout: 'column',
                items: [
                {
			        border: false,
			        columnWidth: 1,
			        height: 27, 
			        items: getCenterListTbar()
                }]
		    },
			{
			    border: false,
			    region: 'center',
			    layout: 'fit', 
                html: '<div id ="PhotoScan"  style="overflow:auto;width:100%;height:100%"  class = "Print"> </div>'
			}]
        }]
    });

//调用dll下载图片
function DisplayPhoto(remotePath)
{
	 //debugger;
	 var path = document.getElementById('imageloader').GetPhotoScan(remotePath);
	 var table = '<table cellpadding="0" cellspacing="0">';
	 table +='<tr><td><img  src="' + path + '"/></td></tr>';
	 table += '<tr><td><a name="controlSroll"></a></td></tr></table>';
	 document.getElementById('PhotoScan').innerHTML = table;
}
function print(){
	 var stxt = document.all.PhotoScan.innerHTML; 
	 stxt = '<title>打印输出</title><scr' + 'ipt type="text/javascript" language="javascript" >function aab(){wb.ExecWB(6,1);} </sc' + 'ript><OBJECT id=wb height=0 width=0 classid=CLSID:8856F961-340A-11D0-A96B-00C04FD705A2 name=wb></OBJECT><body onload="aab()"' + stxt + " </body>"
	 var win = window.open("about:blank ");
     win.document.write(stxt);
     win.document.close();
}

function preview() {
     var stxt = document.all.PhotoScan.innerHTML; 
	 stxt = '<title>打印输出</title><scr' + 'ipt type="text/javascript" language="javascript" >function aab(){wb.ExecWB(7,1);} </sc' + 'ript><OBJECT id=wb height=0 width=0 classid=CLSID:8856F961-340A-11D0-A96B-00C04FD705A2 name=wb></OBJECT><body onload="aab()"' + stxt + " </body>"
	 var win = window.open("about:blank",'newwindow','height='+(window.screen.width-10)+',width='+(window.screen.height-30)+',top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=no,location=no,status=no');
     win.document.write(stxt);
	 win.document.close();
}



