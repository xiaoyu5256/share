
# maven入门
---

# 管理依赖

  手工维护依赖出现的问题：

  - 效率问题，需要一个一个去找
  - 依赖的关联问题，自己维护依赖的关系费劲，容易出错
  - 存储问题，版本管理问题，每个项目依赖，都得为项目拷贝一份lib库,依赖的jar包是否放入版本库


---

# 项目构建

  手工构建的问题

  - 效率问题
  - 项目大了，构建过程过于复杂
  - 无法自动化部署

  Ant的问题

  - 缺少包依赖管理
  - 每个项目都要自己写构建过程，过程大多类似
  - 不强制项目的目录结构，不同项目有不同的目录结构，增加学习成本

---
# 使用maven

新建项目

    mvn archetype:generate 
        -DgroupId=cn.com.chinaratings.demo.mvn 
        -DartifactId=maven_demo 
        -Dversion=1.0.0 
        -DinteractiveMode=false

常用命令

    mvn clean install –X
    mvn dependency:tree
    mvn dependency:build-classpath
    mvn dependency:analyze
    mvn help:system
    mvn help:effective-pom
    mvn intall:help
---
# pom
最简版的pom.xml

    <project>
         <modelVersion>4.0.0</modelVersion>
         <groupId>cn.com.chinaratings.demo</groupId>
         <artifactId>simple-pom</artifactId>
         <version>1.0.0</version>
    </project>

super pom：`MAVEN_HOME/lib/maven-model-builder.jar` 里 `org/apache/maven/model/pom-4.0.0.xml`

---

# pom继承与聚合

继承，从父模块中继承属性，实现复用：

    <parent>
        <groupId>cn.com.chinaratings.demo.parent</groupId>
        <artifactId>ParentProject</artifactId>
        <version>0.0.1-SNAPSHOT</version>
        <relativePath>../ParentProject/pom.xml</relativePath>
    </parent>

聚合，组合几个模块，快速构建项目:

    <modules>
        <module>../module1</module>
        <module>../module1</module>
        <module>../module1</module>
    </modules>


---

# 依赖

- 依赖传递 x->y->z
- 依赖调解 x->y->z x->b->z
- 依赖排除
- 可选依赖 x->y->z y设置z为可选依赖，x则没有对y的依赖，相当于默认依赖排除
- 依赖范围

dependency：

- scope
- optional
- exclusions

---

# 依赖范围

- compile  默认范围，可传递
- provided 编译和测试，不传递
- runtime 运行
- test
- system 不去仓库查找，从本地获取，可指定本地的jdk等
- import


---
# archetype

- http://repo1.maven.org/maven2/archetype-catalog.xml
- USER_HOME/.m2/ archetype-catalog.xml

    mvn archetype:generate -DarchetypeCatalog=local

    mvn archetype:generate
        -DarchetypeCatalog=internal,local,remote

        -DarchetypeCatalog=http://repo.fusesource.com/maven2
        -DarchetypeCatalog=http://cocoon.apache.org
        -DarchetypeCatalog=http://download.java.net/maven/2
        -DarchetypeCatalog=http://myfaces.apache.org
        -DarchetypeCatalog=http://tapestry.formos.com/maven-repository
        -DarchetypeCatalog=http://scala-tools.org
        -DarchetypeCatalog=http://www.terracotta.org/download/reflector/maven2/

    mvn archetype:generate
        -B
        -DgroupId=cn.com.chinaratings
        -DartifactId=demo-maven
        -Dpackage=cn.com.chinaratings
        -Dversion=1.0.0
        -DarchetypeGroupId=org.tinygroup
        -DarchetypeArtifactId=buproject

---
# 插件

插件执行 mvn plugin_prefix:goal

- clean
- compiler
- install
- deploy
- surefire
- site
- jar
- source
- resources
- release
- assembly

---
# 生命周期

- clean
- default
- site

mvn help:describe -Dcmd=install 查看执行的阶段

默认生命周期包含

`validate, initialize, generate-sources, process-sources, generateresources, process-resources, compile, process-classes, generate-test-sources, process-test-sources, generate-testresources, process-test-resources, test-compile, process-testclasses, test, prepare-package, package, pre-integration-test, integration-test, post-integration-test, verify, install, deploy`

执行`mvn install`,相当于把默认生命周期里的从开始到`install`阶段按顺序执行一遍

---
# 生命周期定义

定义在 MAVEN_HOME/lib/maven-core- 3.3.3.jar中 META-INF/plex/components.xml 里
---

