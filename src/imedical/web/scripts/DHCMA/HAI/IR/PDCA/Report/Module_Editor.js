//加载'富文本编辑'相关内容
function InitPARepWinEditor(obj){
	//初始化'富文本编辑框'
	obj.LoadEditor=function(ID,Width,Height){
		UM.delEditor(ID); 		//先删除之前实例的对象
		var um =UM.getEditor(ID,{
			//这里可以选择自己需要的工具按钮名称,此处仅选择如下七个
			toolbar:[
				'source | undo redo | bold italic underline | forecolor backcolor | removeformat |',
				'insertorderedlist insertunorderedlist | cleardoc | ',
				'justifyleft justifycenter justifyright justifyjustify |',
				'horizontal'
			],
            //focus时自动清空初始化时的内容
            autoClearinitialContent:true,
            //关闭字数统计
            wordCount:false,
            //关闭elementPath
            elementPathEnabled:false,
            //默认的编辑区域高度
            initialFrameHeight:Height,
            //默认的编辑区域高度
            initialFrameWidth:Width,
            //更多其他参数，请参考umeditor.config.js中的配置项
            autoHeightEnabled: false
        });
	}
	
}