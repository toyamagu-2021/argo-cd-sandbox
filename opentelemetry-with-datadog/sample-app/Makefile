.PHONY: docker.build
docker.build:
  docker buildx build --platform linux/amd64 -t ${REPO_NAME} .
	docker tag ${REPO_NAME}:latest ${ECR_REGISTORY}/${REPO_NAME}:latest
