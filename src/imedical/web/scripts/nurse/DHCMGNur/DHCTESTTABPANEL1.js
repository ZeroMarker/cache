/**
 * @author Qse
 */
Ext.onReady(function(){
       Ext.QuickTips.init();
       var tabsDemo=new Ext.TabPanel({
              renderTo:Ext.getBody(),
              //resizeTabs:true,宽度能自动变化,但是影响标题的显示
              activeTab:0,
              height:200,
              enableTabScroll:true,//挤的时候能够滚动收缩
              width:200,
            frame:true,
         items:[{
                    title:"tab advantage",
                 html:"sample1"
            }]
  });
     var index=0;
  //就是下面这个函数,关键的地方,非常简单也非常实用
    function addTab(){
        tabsDemo.add({
                   title:"newtab",
                id:"newtab"+index,
                   html:"new tab"+index,
                closable:true
           });
        tabsDemo.setActiveTab("newtab"+index);
           index++;
 }
    //设置一个按钮(上面的是一个链接,应用有点不同哦)
new Ext.Button({
        text:"添加新标签页",
     handler:addTab
   }).render(document.body,"AddBtn");
});
