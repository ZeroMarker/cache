<style>
	img {
		border: 1px solid #ccc; 
		border-radius: 4px;
	}
</style>
##1、<trans>关于任务的说明</trans>
<trans>系统任务是通过数据库管理门户(Management Portal)添加的任务，可以将其视为一组任务，这一组任务下面可以有许多的任务明细。比如药房药库的任务很多都是凌晨00:00:01执行的，我们可以将这些任务集中在一起，只挂一个系统任务（也即一组任务），然后再此系统任务下新建多个明细任务，例如：调价生效、清理在途、清理门诊清24小时在途、病区基数药自动发药、药库日报等等。如下：</trans>
![](imgs/pha.sys.v1.taskcfg_01.png)


##2、<trans>如何新建系统任务</trans>
###(1) <trans>登录数据库管理门户(Management Portal)。如下</trans>：
<trans>选择Management Portal</trans>：<br/>
![](imgs/pha.sys.v1.taskcfg_02_01.png)<br/>

<trans>进入登记界面</trans>：<br/>
![](imgs/pha.sys.v1.taskcfg_02_02.png)

###(2) <trans>选择【系统操作 - 任务管理器 - 新任务 - 开始】，如下</trans>：
![](imgs/pha.sys.v1.taskcfg_03.png)

###(3) <trans>按如下输入任务信息，然后点击下一步</trans>：
<trans>注意：此处的“任务类型”须选择“运行传统任务”（“运行旧任务”或者“%SYS.Task.RunLegacyTask”），ExecuteCode需要写药房药库通用的类方法d ##class(PHA.COM.TASK.Api).RunAll()，才能在【药品系统管理 - 任务管理 - 任务维护】界面查询出来。</trans>
![](imgs/pha.sys.v1.taskcfg_04.png)

###(4) <trans>按如下输入任务信息，然后点击完成</trans>：
![](imgs/pha.sys.v1.taskcfg_05.png)

###(5) <trans>查看任务，如下</trans>：
<trans>选择【系统操作 - 任务管理器 - 任务计划 - 开始】</trans>：<br/>
![](imgs/pha.sys.v1.taskcfg_06_01.png)<br/>

<trans>可以看到刚刚新建的任务</trans>：<br/>
![](imgs/pha.sys.v1.taskcfg_06_02.png)

<trans>点击【RUN】可以进入运行任务的界面</trans>：<br/>
![](imgs/pha.sys.v1.taskcfg_06_03.png)<br/>

<trans>点击【立即执行操作】可以执行新建的任务，如下</trans>：<br/>
![](imgs/pha.sys.v1.taskcfg_06_04.png)<br/>

![](imgs/pha.sys.v1.taskcfg_06_05.png)<br/>

###(7) <trans>配置界面维护系统任务，如下</trans>：
<trans>注意此处维护的“系统任务名称”应该与在Portal挂任务是填写的“任务名称”一致，如下</trans>：<br/>
![](imgs/pha.sys.v1.taskcfg_08_01.png)<br/>

![](imgs/pha.sys.v1.taskcfg_08_02.png)<br/>