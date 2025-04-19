// ComfyUI Docker Bake file
variable "RELEASE" {
    default = "1.0.0"
}

variable "COMFYUI_VERSION" {
    default = "v0.3.29"
}

variable "DOCKERHUB_REPO" {
    default = "buttonscodes"
}

variable "DOCKERHUB_IMG" {
    default = "bc-combined"
}

// For GitHub Actions compatibility
variable "GITHUB_WORKSPACE" {
    default = "/root/runpod-containers"
}

target "default" {
    context = "${GITHUB_WORKSPACE}/bc-templates/bc-combined"
    dockerfile = "${GITHUB_WORKSPACE}/bc-templates/bc-combined/Dockerfile"
    tags = ["${DOCKERHUB_REPO}/${DOCKERHUB_IMG}:${RELEASE}"]
    platforms = ["linux/amd64"]
    contexts = {
        scripts = "${GITHUB_WORKSPACE}/container-template"
        proxy = "${GITHUB_WORKSPACE}/container-template/proxy"
    }
    args = {
        COMFYUI_VERSION = "${COMFYUI_VERSION}"
        RELEASE = "${RELEASE}"
        GITHUB_WORKSPACE = "${GITHUB_WORKSPACE}"
    }
}
