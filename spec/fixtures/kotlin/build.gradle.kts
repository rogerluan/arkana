plugins {
    kotlin("jvm") version "1.8.20"
    application
}

group = "com.arkanakeys"

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

kotlin {
    jvmToolchain(11)
}
