package com.asiainfo.domain;
/**
 * @Copyright Copyright (c) 2014 Asiainfo
 *
 * @ClassName:     User.java
 * @Description:   TODO(users表所对应的实体类) 
 * 
 * @author         hetao5
 * @version        V1.0  
 * @Date           2015-11-11 下午3:54:23 
 */
public class User {
	//实体类的属性和表的字段名称一一对应
    private int id;
    private String name;
    private int age;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    @Override
    public String toString() {
        return "User [id=" + id + ", name=" + name + ", age=" + age + "]";
    }

}
