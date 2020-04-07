#!groovy
// ----------------------------------------------------------------------------
//  SPDX-FileCopyrightText: © 2020 The Spectrecoin developers
//  SPDX-License-Identifier: MIT/X11
//
//  @author   HLXEasy <helix@spectreproject.io>
// ----------------------------------------------------------------------------

pipeline {
    agent {
        label "housekeeping"
    }
    options {
        timestamps()
        timeout(time: 4, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '1'))
        disableConcurrentBuilds()
    }
    environment {
        // In case another branch beside master or develop should be deployed, enter it here
        BRANCH_TO_DEPLOY = 'automateWindowsInstallerCreation'
        DISCORD_WEBHOOK = credentials('991ce248-5da9-4068-9aea-8a6c2c388a19')
        CURRENT_DATE = sh(
                script: "printf \"\$(date '+%F %T')\"",
                returnStdout: true
        )
    }
    parameters {
        string(name: 'ARCHIVE_LOCATION', defaultValue: '', description: 'Location of the Spectrecoin archive with the content for the installer')
        string(name: 'ARCHIVE_NAME', defaultValue: '', description: 'Name of Spectrecoin archive with the content for the installer')
        string(name: 'GIT_TAG_TO_USE', defaultValue: '', description: 'Spectrecoin version to package into installer')
        string(name: 'GIT_COMMIT_SHORT', defaultValue: '', description: 'Spectrecoin version to package into installer')
    }
    stages {
        stage('Notification') {
            steps {
                // Using result state 'ABORTED' to mark the message on discord with a white border.
                // Makes it easier to distinguish job-start from job-finished
                discordSend(
                        description: "Started build #$env.BUILD_NUMBER",
                        image: '',
                        link: "$env.BUILD_URL",
                        successful: true,
                        result: "ABORTED",
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        stage('Start Windows slave') {
            when {
                anyOf { branch 'master'; branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
            steps {
                withCredentials([[
                                         $class           : 'AmazonWebServicesCredentialsBinding',
                                         credentialsId    : '91c4a308-07cd-4468-896c-3d75d086190d',
                                         accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                         secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                 ]]) {
                    sh(
                            script: """
                                docker run \
                                    --rm \
                                    --env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                                    --env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                                    --env AWS_DEFAULT_REGION=eu-west-1 \
                                    garland/aws-cli-docker \
                                    aws ec2 start-instances --instance-ids i-06fb7942772e77e55
                            """
                    )
                }
            }
        }
        stage('Create installer') {
            agent {
                label "windows"
            }
            when {
                anyOf { branch 'master'; branch 'develop'; branch "${BRANCH_TO_DEPLOY}" }
            }
            steps {
                script {
                    prepareWindowsInstallerContent(
                            archiveLocation: "${ARCHIVE_LOCATION}",
                            archiveName: "${ARCHIVE_NAME}"
                    )
                    bat 'windows\\createInstaller.bat'
                    fileOperations([
                            fileRenameOperation(
                                    source: "${WORKSPACE}/windows/Spectrecoin-Installer.zip",
                                    destination: "${WORKSPACE}/windows/Spectrecoin-${GIT_TAG_TO_USE}-${GIT_COMMIT_SHORT}-Win64-Installer.zip"),
                    ])
                    archiveArtifacts allowEmptyArchive: false, artifacts: "Spectrecoin-${GIT_TAG_TO_USE}-${GIT_COMMIT_SHORT}-Win64-Installer.zip"
                }
            }
        }
        stage('Upload deliveries') {
            steps {
                script {
                    sh(
                            script: """
                                rm -f Spectrecoin-*-Win64-Installer.zip
                                wget https://ci.spectreproject.io/job/Spectrecoin/job/installer/job/${GIT_BRANCH}/${BUILD_NUMBER}/artifact/Spectrecoin-${GIT_TAG_TO_USE}-${GIT_COMMIT_SHORT}-Win64-Installer.zip
                            """
                    )
                    uploadArtifactToGitHub(
                            user: 'spectrecoin',
                            repository: 'spectre',
                            tag: "${GIT_TAG_TO_USE}",
                            artifactNameRemote: "Spectrecoin-${GIT_TAG_TO_USE}-${GIT_COMMIT_SHORT}-Win64-Installer.zip",
                    )
//                    createAndArchiveChecksumFile(
//                            filename: "Spectrecoin-${GIT_TAG_TO_USE}-${GIT_COMMIT_SHORT}-Win64-Installer.zip",
//                            checksumfile: "Checksum-Spectrecoin-Win64-Installer.txt"
//                    )
                    sh "rm -f Spectrecoin-*-Win64-Installer.zip Checksum-Spectrecoin-Win64-Installer.txt"
                }
            }
        }
    }
    post {
        success {
            script {
                if (!hudson.model.Result.SUCCESS.equals(currentBuild.getPreviousBuild()?.getResult())) {
                    emailext(
                            subject: "GREEN: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                            body: '${JELLY_SCRIPT,template="html"}',
                            recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                            to: "to@be.defined",
//                            replyTo: "to@be.defined"
                    )
                }
                discordSend(
                        description: "Build #$env.BUILD_NUMBER finished successfully",
                        image: '',
                        link: "$env.BUILD_URL",
                        successful: true,
                        thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                        title: "$env.JOB_NAME",
                        webhookURL: "${DISCORD_WEBHOOK}"
                )
            }
        }
        unstable {
            emailext(
                    subject: "YELLOW: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                    body: '${JELLY_SCRIPT,template="html"}',
                    recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                    to: "to@be.defined",
//                    replyTo: "to@be.defined"
            )
            discordSend(
                    description: "Build #$env.BUILD_NUMBER finished unstable",
                    image: '',
                    link: "$env.BUILD_URL",
                    successful: true,
                    result: "UNSTABLE",
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
        failure {
            emailext(
                    subject: "RED: '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                    body: '${JELLY_SCRIPT,template="html"}',
                    recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'RequesterRecipientProvider']],
//                    to: "to@be.defined",
//                    replyTo: "to@be.defined"
            )
            discordSend(
                    description: "Build #$env.BUILD_NUMBER failed!",
                    image: '',
                    link: "$env.BUILD_URL",
                    successful: false,
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
        aborted {
            discordSend(
                    description: "Build #$env.BUILD_NUMBER was aborted",
                    image: '',
                    link: "$env.BUILD_URL",
                    successful: true,
                    result: "ABORTED",
                    thumbnail: 'https://wiki.jenkins-ci.org/download/attachments/2916393/headshot.png',
                    title: "$env.JOB_NAME",
                    webhookURL: "${DISCORD_WEBHOOK}"
            )
        }
    }
}
